class CreateTenderController < ApplicationController
  before_action :set_request, only: [:edit_project_information, :edit_documents, :edit_boq, :edit_questionnaire, :edit_participants,
                                     :update_project_information, :update_documents, :update_boq, :update_questionnaire, :update_participants,
                                     :preview]

  before_action :authenticate_quantity_surveyor!, only: [:edit, :index]



  def edit_project_information
    @next_path = request_for_tenders_documents_path
  end

  def update_project_information
    respond_to do |format|
      if @request.update(request_params)
        format.js
      else
        format.js
      end
    end
  end



  def edit_documents
    @next_path = request_for_tenders_boq_path

    if @request.project_documents.length < 5
      (5 - @request.project_documents.length).times { @request.project_documents.build }
    else
      @request.project_documents.build
    end
  end

  def update_documents
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to request_for_tenders_documents_path(@request), notice: 'All changes saved.' }
        format.js
      else
        format.js
      end
    end
  end



  def edit_boq
    @next_path = request_for_tenders_questionnaire_path

    @request.build_excel
    gon.jbuilder
  end

  def update_boq
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to request_for_tenders_boq_path(@request), notice: 'All changes saved.' }
        format.js
      else
        format.js
      end
    end
  end



  def edit_questionnaire
    @next_path = request_for_tenders_participants_path

    if @request.questions.length < 1
      (1 - @request.questions.length).times { @request.questions.build }
    else
      @request.questions.build
    end
  end

  def update_questionnaire
    respond_to do |format|
      if @request.update(request_params)
        format.js
      else
        format.js
      end
    end
  end



  def edit_participants
    @next_path = request_for_tenders_preview_path

    if @request.participants.length < 5
      (5 - @request.participants.length).times { @request.participants.build }
    else
      @request.participants.build
    end
  end


  def update_participants
    respond_to do |format|
      if @request.update(request_params)
        format.js
      else
        format.js
      end
    end
  end



  def preview
    @next_path = request_for_tenders_documents_path
  end


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
