# frozen_string_literal: true

class Tenders::RequiredDocumentUploadsController < ApplicationController
  before_action :set_tender
  before_action :set_required_document_upload, only: :destroy

  def create
    @required_document_upload = @tender
                                .required_document_uploads
                                .new(required_document_upload_params)

    if @required_document_upload.save
      @required_document_upload.reload
      render json: @required_document_upload, status: :created
    else
      render json: @required_document_upload.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @required_document_upload.destroy
    head :no_content
  end

  private

  def set_tender
    @tender = current_contractor
              .tenders
              .find(params[:tender_id])
  end

  def set_required_document_upload
    @required_document_upload = @tender
                                .required_document_uploads
                                .find(params[:id])
  end

  def required_document_upload_params
    params.require(:required_document_upload).permit(:document,
                                                     :required_document_id)
  end
end
