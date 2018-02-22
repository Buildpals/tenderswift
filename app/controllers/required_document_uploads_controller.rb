class RequiredDocumentUploadsController < ApplicationController

  def create
    puts params
  end


  private

  def required_document_upload_params
    params.require(:required_document_upload).permit(:status, :required_document_id,
                                                     :participant_id, :document)
  end
end
