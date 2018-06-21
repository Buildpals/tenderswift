# frozen_string_literal: true

class RequestForTenders::BuildController < QuantitySurveyorsController
  include Wicked::Wizard

  before_action :set_policy

  steps :general_information,
        :bill_of_quantities,
        :tender_documents,
        :tender_instructions,
        :distribution

  def show
    @request_for_tender = RequestForTender.find(params[:request_for_tender_id])
    authorize @request_for_tender
    render_wizard
  end

  def update
    @request_for_tender = RequestForTender.find(params[:request_for_tender_id])
    authorize @request_for_tender

    if step == steps.last
      @request_for_tender.published_at = Time.current
      @request_for_tender.status = :active
    else
      @request_for_tender.status = step.to_s
    end
    @request_for_tender.update_attributes(request_params)
    render_wizard @request_for_tender
  end

  def create
    @request_for_tender = current_quantity_surveyor.request_for_tenders.new
    authorize @request_for_tender
    @request_for_tender.setup_with_data

    redirect_to wizard_path(steps.first,
                            request_for_tender_id: @request_for_tender.id)
  end

  private

  def finish_wizard_path
    request_for_tender_path(@request_for_tender)
  end

  def set_policy
    RequestForTender.define_singleton_method(:policy_class) do
      BuildRequestForTenderPolicy
    end
  end

  def request_params
    params.require(:request_for_tender)
          .permit(:project_name,
                  :deadline,
                  :city,
                  :description,
                  :country_code,
                  :currency,
                  :tender_instructions,
                  :selling_price,
                  :withdrawal_frequency,
                  :bank_name,
                  :branch_name,
                  :account_name,
                  :account_number,
                  :private,
                  list_of_items: [
                    :updated_at,
                    items: %i[name description quantity unit isHeader]
                  ],
                  project_documents_attributes: %i[id
                                                   document
                                                   _destroy],
                  contract_sum_address: %i[sheet cellAddress],
                  required_documents_attributes: %i[id
                                                    title
                                                    _destroy])
  end
end
