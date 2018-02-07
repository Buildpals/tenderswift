class CreateTenderController < ApplicationController
  before_action :set_request, only: [:edit_tender_information, :edit_tender_documents, :edit_tender_boq, :edit_tender_questionnaire, :edit_tender_participants,
                                     :update_tender_information, :update_tender_documents, :update_tender_boq, :update_tender_questionnaire, :update_tender_participants]

  before_action :authenticate_quantity_surveyor!

  DEFAULT_BROADCAST_CONTENT = "If you have any questions you can reply me here".freeze

  def edit_tender_information
    if @request.submitted?
      redirect_to request_for_tenders_path, notice: 'A tender cannot
                                            be edited once it\'s sent out
                                            to contractors'
    else
      @next_path = edit_tender_boq_path(@request)
    end
  end

  def update_tender_information
    if @request.update(request_params)
      if params[:commit] == 'Next'
        redirect_to edit_tender_boq_path(@request)
      else
        redirect_to edit_tender_information_path(@request)
      end
    else
      render :edit_tender_information
    end
  end


  def edit_tender_boq
    @next_path = edit_tender_documents_path(@request)
    #@request.build_excel
    #gon.jbuilder
  end

  def update_tender_boq
    if @request.update(request_params)
      if params[:commit] == 'Back'
        redirect_to edit_tender_information_path(@request)
      elsif params[:commit] == 'Next'
        redirect_to edit_tender_documents_path(@request)
      else
        redirect_to edit_tender_boq_path(@request)
      end
    else
      render :edit_tender_boq
    end
  end


  def edit_tender_documents
    @next_path = edit_tender_questionnaire_path(@request)

    5.times {@request.project_documents.build} if @request.project_documents.empty?
  end

  def update_tender_documents
    if @request.update(request_params)
      if params[:commit] == 'Back'
        redirect_to edit_tender_boq_path(@request)
      elsif params[:commit] == 'Next'
        redirect_to edit_tender_questionnaire_path(@request)
      else
        redirect_to edit_tender_documents_path(@request)
      end
    else
      render :edit_tender_documents
    end
  end


  def edit_tender_questionnaire
    @next_path = edit_tender_participants_path(@request)

    @request.questions.build if @request.questions.empty?
  end

  def update_tender_questionnaire
    if @request.update(request_params)
      if params[:commit] == 'Back'
        redirect_to edit_tender_documents_path(@request)
      elsif params[:commit] == 'Next'
        redirect_to edit_tender_participants_path(@request)
      else
        redirect_to edit_tender_questionnaire_path(@request)
      end
    else
      render :edit_tender_questionnaire
    end
  end


  def edit_tender_participants
    5.times {@request.participants.build} if @request.participants.empty?
  end


  def update_tender_participants
    if @request.update(request_params)
      if params[:commit] == 'Back'
        redirect_to edit_tender_questionnaire_path(@request)
      elsif params[:commit] == 'Submit'
        email_participants
      else
        redirect_to edit_tender_participants_path
      end
    else
      render :edit_tender_participants
    end
  end

  private

  def email_participants
    if @request.submitted?
      redirect_to @request,
                  notice: 'The participants of this request have been contacted already'
    elsif @request.participants.empty?
      redirect_to edit_tender_participants_path(@request),
                  alert: 'You did not specify any participants for the request.'
    else
      send_emails_to_participants
      redirect_to @request, notice: 'An email has been sent to each participant of this request.'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = RequestForTender.find(params[:id])
    @participant = GuestParticipant.new(@request)
  end

  def send_emails_to_participants
    @request.participants.each do |participant|
      ParticipantMailer.request_for_tender_email(participant, @request).deliver_later
    end

    @request.update(submitted: true)
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
                :currency,
                :contract_sum,
                :tender_instructions,
                project_documents_attributes: [:id,
                                               :document,
                                               :_destroy],
                participants_attributes: [:id,
                                          :email,
                                          :phone_number,
                                          :company_name,
                                          :_destroy],
                questions_attributes: [:id,
                                       :number,
                                       :title,
                                       :description,
                                       :question_type,
                                       :can_attach_documents,
                                       :mandatory,
                                       :_destroy],
                boq_attributes: [:id,
                                 :workbook_data,
                                 :quantity_column,
                                 :amount_column,
                                 :item_column,
                                 :unit_column,
                                 :rate_column,
                                 :remind_me,
                                 :_destroy],
                excel_attributes: [:id,
                                   :document])
  end
end
