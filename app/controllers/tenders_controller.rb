# frozen_string_literal: true

class TendersController < ContractorsController
  before_action :set_tender
  before_action :return_if_not_purchased, except: %i[project_information]

  include ApplicationHelper

  before_action :authenticate_contractor!

  include Pundit # for development purposes only
  after_action :verify_authorized # for development purposes only

  def project_information
  	authorize  @tender
  end

  def tender_documents
  	authorize @tender
   end

  def boq
  	authorize @tender
  end

  def contractors_documents
  	authorize @tender
    	@tender.build_required_document_uploads
  end

  def results; end

  def save_rates
    if @tender.save_rates(params[:rates])
      render json: @tender.to_json(include: :rates), status: :ok,
             location: @tender
    else
      render json: @tender.errors, status: :unprocessable_entity
    end
  end

  def save_contractors_documents
    if @tender.update(tender_params)
      redirect_to tenders_contractors_documents_path(@tender)
    else
      flash[:notice] = 'There was an error while uploading the file'
      render :contractors_documents
    end
  end

  private

  def set_tender
    @tender = Tender.find(params[:id])
    if @tender.nil?
      redirect_to root_path
    else
      @request_for_tender = @tender.request_for_tender
    end
  end

  def return_if_not_purchased
    redirect_to tenders_project_information_path(@tender) unless @tender.purchased?
  end

  def tender_params
    params.require(:tender)
          .permit(other_document_uploads_attributes: %i[id
                                                        name
                                                        document
                                                        _destroy],
                  required_document_uploads_attributes: %i[id
                                                           document
                                                           required_document_id
                                                           tender_id
                                                           _destroy])
  end
end
