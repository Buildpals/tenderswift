# frozen_string_literal: true

class Tenders::OtherDocumentUploadsController < ApplicationController
  before_action :set_tender
  before_action :set_other_document_upload, only: :destroy

  def create
    params[:other_document_upload][:original_file_name] =
      params[:other_document_upload][:document].original_filename

    params[:other_document_upload][:title] =
        params[:other_document_upload][:document].original_filename

    @other_document_upload = @tender
                        .other_document_uploads
                        .new(other_document_upload_params)

    if @other_document_upload.save
      @other_document_upload.reload
      render json: @other_document_upload, status: :created
    else
      render json: @other_document_upload.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @other_document_upload.destroy
    head :no_content
  end

  private

  def set_tender
    @tender = current_contractor
                          .tenders
                          .find(params[:tender_id])
  end

  def set_other_document_upload
    @other_document_upload = @tender
                        .other_document_uploads
                        .find(params[:id])
  end

  def other_document_upload_params
    params.require(:other_document_upload).permit(:document, :original_file_name)
  end
end
