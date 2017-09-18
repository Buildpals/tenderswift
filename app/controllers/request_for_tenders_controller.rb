class RequestForTendersController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy,
                                     :email_request_for_tender]

  before_action :authenticate_quantity_surveyor!, only: [:edit, :index]

  # GET /requests
  # GET /requests.json
  def index
    @requests = current_quantity_surveyor.request_for_tenders.order(updated_at: :desc)
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
    gon.jbuilder
  end

  # GET /requests/new
  def new
    country = Country.first
    @request = RequestForTender.new(project_name: 'Untitled Project',
                                    country: country,
                                    deadline: Time.current + 7.days)
    @request.quantity_surveyor = current_quantity_surveyor
    @request.create_blank_boq
    @request.save!
    redirect_to edit_request_for_tender_path @request
  end

  # GET /requests/1/edit
  def edit
    @request.build_excel
    if @request.participants.length < 3
      (3 - @request.participants.length).times { @request.participants.build }
    else
      @request.participants.build
    end

    if @request.project_documents.length < 2
      (2 - @request.project_documents.length).times { @request.project_documents.build }
    else
      @request.project_documents.build
    end

    gon.jbuilder
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = RequestForTender.new(request_params)
    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    case params[:commit]
      when 'Previous'
        @request.current_step = @request.previous_step
      when 'Save & Continue'
        @request.current_step = @request.next_step
    end
    respond_to do |format|
      if @request.update(request_params)
        format.html {
            if params[:commit] == 'Send Request Out'
              redirect_to email_request_for_tender_path(@request)
            else
              redirect_to edit_request_for_tender_path(@request), notice: 'Request was successfully updated.'
            end
        }
        format.json { render :show, status: :ok, location: @request }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /email_request_for_tender/1
  def email_request_for_tender
    if @request.submitted?
      redirect_to @request,
                  notice: 'The participants of this request have been contacted already'
    elsif @request.participants.empty?
      redirect_to edit_request_for_tender_path(@request),
                  alert: 'You did not specify any participants in this request.'
    else
      @request.participants.each do |participant|
        # Tell the ParticipantMailer to send a request_for_tender email
        ParticipantMailer.request_for_tender_email(participant).deliver_later
      end
      @request.update(submitted: true)
      redirect_to @request, notice: 'An email has been sent to each participant of this request.'
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to request_for_tenders_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = RequestForTender.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def request_params
    params.require(:request_for_tender)
          .permit(:project_name,
                  :deadline,
                  :country_id,
                  :city,
                  :description,
                  :budget_currency,
                  :budget,
                  project_documents_attributes: [:id,
                                                 :document,
                                                 :_destroy],
                  participants_attributes: [:id,
                                            :email,
                                            :phone_number,
                                            :company_name,
                                            :_destroy],
                  questions_attributes: [:id,
                                         :email,
                                         :phone_number,
                                         :company_name,
                                         :_destroy],
                  excel_attributes: [:id,
                                     :document])
  end
end
