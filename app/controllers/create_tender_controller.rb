class CreateTenderController < ApplicationController
  before_action :set_request, only: [:edit_tender_information, :edit_tender_documents, :edit_tender_boq, :edit_tender_questionnaire, :edit_tender_participants,
                                     :update_tender_information, :update_tender_documents, :update_tender_boq, :update_tender_questionnaire, :update_tender_participants]

  before_action :authenticate_quantity_surveyor!, only: [:edit, :index]


  def edit_tender_information
    @next_path = edit_tender_documents_path(@request)
  end

  def update_tender_information
    respond_to do |format|
      if @request.update(request_params)
        format.js
      else
        format.js
      end
    end
  end


  def edit_tender_documents
    @next_path = edit_tender_boq_path(@request)

    5.times {@request.project_documents.build} if @request.project_documents.empty?
  end

  def update_tender_documents
    respond_to do |format|
      if @request.update(request_params)
        format.html {redirect_to edit_tender_documents_path(@request), notice: 'All changes saved.'}
        format.js
      else
        format.js
      end
    end
  end


  def edit_tender_boq
    @next_path = edit_tender_questionnaire_path(@request)

    @request.build_excel
    gon.jbuilder
  end

  def update_tender_boq
    respond_to do |format|
      if @request.update(request_params)
        format.html {redirect_to edit_tender_boq_path(@request), notice: 'All changes saved.'}
        format.js
      else
        format.js
      end
    end
  end


  def edit_tender_questionnaire
    @next_path = edit_tender_participants_path(@request)

    @request.questions.build if @request.questions.empty?
  end

  def update_tender_questionnaire
    respond_to do |format|
      if @request.update(request_params)
        format.js
      else
        format.js
      end
    end
  end


  def edit_tender_participants
    5.times {@request.participants.build} if @request.participants.empty?
  end


  def update_tender_participants
    respond_to do |format|
      if @request.update(request_params)
        format.js
      else
        format.js
      end
    end
  end


  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = RequestForTender.find(params[:id])
    @participant = GuestParticipant.new(@request)
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
                :contract_sum,
                :contract_sum_currency,
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
                excel_attributes: [:id,
                                   :document])
  end
end
