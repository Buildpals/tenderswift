class RequestForTendersController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy,
                                     :email_request_for_tender]

  # GET /requests
  # GET /requests.json
  def index
    @requests = RequestForTender.order(updated_at: :desc)
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  # GET /requests/new
  def new
    @request = RequestForTender.create(project_name: '[Untitled request]',
                                       deadline: Time.current + 7.days)
    redirect_to edit_request_for_tender_path @request
  end

  # GET /requests/1/edit
  def edit
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = RequestForTender.new(request_params)

    respond_to do |format|
      if @request.save
        format.html {redirect_to @request, notice: 'Request was successfully created.'}
        format.json {render :show, status: :created, location: @request}
      else
        format.html {render :new}
        format.json {render json: @request.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    process_excel_file if params[:request_for_tender][:excel]

    respond_to do |format|
      if @request.update(request_params)
        format.html {redirect_to (edit_request_for_tender_path @request), notice: 'Request was successfully updated.'}
        format.json {render :show, status: :ok, location: @request}
      else
        format.html {render :edit}
        format.json {render json: @request.errors, status: :unprocessable_entity}
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
      format.html {redirect_to request_for_tenders_url, notice: 'Request was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  def process_excel_file
    #upload file temporarily to read
    uploaded_io = params[:request_for_tender][:excel]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    #upload file to cloudinary
    excel = Excel.new; excel.document = params[:request_for_tender][:excel]
    @request.excel = excel
    excel.save!

    file_path = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
    ReadExcelJob.perform_later(file_path.to_s, @request)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = RequestForTender.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def request_params
    params.require(:request_for_tender).permit(:project_name,
                                               :deadline,
                                               :country,
                                               :city,
                                               :description,
                                               :budget,
                                               project_documents_attributes: [:id,
                                                                              :document,
                                                                              :_destroy],
                                               participants_attributes: [:id,
                                                                         :email,
                                                                         :phone_number,
                                                                         :_destroy])
  end
end
