class RequiredDocumentUploadsController < ApplicationController

  before_action :authenticate_quantity_surveyor!

  def create
    puts params
  end


  private

  def required_document_upload_params
    params.require(:required_document_upload).permit(:status, :required_document_id,
                                                     :tender_id, :document)
  end
end
