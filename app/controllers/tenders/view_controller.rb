# frozen_string_literal: true

class Tenders::ViewController < ContractorsController
  include Wicked::Wizard

  before_action :set_tender

  before_action :set_policy

  steps :general_information,
        :tender_documents,
        :bill_of_quantities,
        :upload_documents,
        :results

  def show
    authorize @tender
    render_wizard
  end

  def update
    if @tender.update(tender_params)
      render json: @tender, status: :ok, location: @tender
    else
      render json: @tender.errors, status: :unprocessable_entity
    end
  end

  def save_rates
    authorize @tender
    if @tender.save_rates(params[:rates])
      render json: @tender.to_json(include: :rates),
             status: :ok,
             location: @tender
    else
      render json: @tender.errors, status: :unprocessable_entity
    end
  end

  def save_contractors_documents
    authorize @tender
    if @tender.update(tender_params)
      redirect_to tenders_contractors_documents_path(@tender)
    else
      flash[:notice] = 'There was an error while uploading the file'
      render :uploaded_documents
    end
  end

  def submit_tender
    authorize @tender
    if @tender.update(submitted_at: Time.current)
      redirect_to tenders_contractors_documents_path(@tender),
                  notice: 'Tender submitted successfully.'
    else
      @tender.submitted_at = nil
      @tender.build_required_document_uploads
      render layout: 'tenders', action: :uploaded_documents
    end
  end

  private

  def set_policy
    Tender.define_singleton_method(:policy_class) { TenderPolicy }
  end

  def set_tender
    @tender = current_contractor.tenders.find(params[:tender_id])
  end

  def tender_params
    params.require(:tender)
          .permit(
            :reference_number,
            list_of_rates: [
              :updated_at,
              rates: {}
            ],
            other_document_uploads_attributes: %i[id
                                                  name
                                                  document
                                                  _destroy],
            required_document_uploads_attributes: %i[id
                                                     document
                                                     required_document_id
                                                     tender_id
                                                     _destroy]
          )
  end
end