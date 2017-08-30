class RequestForTendersController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]

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
    #upload file temporarily to read
    if params[:request_for_tender][:excel].present?
      uploaded_io = params[:request_for_tender][:excel]
      File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end
      file_path = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
      #upload file to cloudinary
      excel = Excel.new; excel.document = params[:request_for_tender][:excel]
      @request.excel = excel
      excel.save!
      ReadExcelJob.perform_later(file_path.to_s, @request)
    end

    respond_to do |format|
      if @request.update(request_params)
        send_request_out(@request) if params[:send_emails_out] == 'true'   
        format.html {redirect_to (edit_request_for_tender_path @request), notice: 'Request was successfully updated.'}
        format.json {render :show, status: :ok, location: @request}
      else
        format.html {render :edit}
        format.json {render json: @request.errors, status: :unprocessable_entity}
      end
    end
  end

  def send_request_out(request)
    request.participants.each do |participant|
      # Tell the ParticipantMailer to send a request_for_tender email after save
      ParticipantMailer.request_for_tender_email(participant).deliver_later
    end
    request.update(submitted: true)
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
                                               :send_emails_out,
                                               project_documents_attributes: [:id,
                                                                              :document,
                                                                              :_destroy],
                                               participants_attributes: [:id,
                                                                         :email,
                                                                         :phone_number,
                                                                         :_destroy])
  end
end
