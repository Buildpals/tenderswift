# frozen_string_literal: true

class ProjectDocumentsController < PublishersController
  before_action :set_request_for_tender
  before_action :set_project_document, only: :destroy

  def create
    params[:project_document][:original_file_name] =
      params[:project_document][:document].original_filename

    @project_document = @request_for_tender
                        .project_documents
                        .new(project_document_params)

    if @project_document.save
      @project_document.reload
      render json: @project_document, status: :created
    else
      render json: @project_document.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @project_document.destroy
    head :no_content
  end

  private

  def set_request_for_tender
    @request_for_tender = current_publisher
                          .request_for_tenders
                          .find(params[:request_for_tender_id])
  end

  def set_project_document
    @project_document = @request_for_tender
                        .project_documents
                        .find(params[:id])
  end

  def project_document_params
    params.require(:project_document).permit(:document, :original_file_name)
  end
end
