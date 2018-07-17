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

    if step == steps.last && current_admin
      publish_the_request_for_tender(@request_for_tender)
    elsif step == steps.last
      submit_the_request_for_tender(@request_for_tender)
    elsif step == :bill_of_quantities
      save_the_changes(@request_for_tender, stay: true)
    else
      save_the_changes(@request_for_tender)
    end
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
    quantity_surveyor_root_path
  end

  def publish_the_request_for_tender(request_for_tender)
    has_published = true if request_for_tender.published_at
    request_for_tender.published_at = Time.current
    request_for_tender.status = :active
    request_for_tender.update_attributes(request_params)
    if has_published == true
      AdminMailer.publish_request_for_tender(request_for_tender).deliver_now
    end
    # Send an email telling the quantity surveyor his request for tender has
    # been published
    render_wizard request_for_tender,
                  notice: 'The tender has been published successfully'
  end

  def submit_the_request_for_tender(request_for_tender)
    new_request = true if request_for_tender.submitted_at.nil?
    request_for_tender.submitted_at = Time.current
    request_for_tender.status = :active
    request_for_tender.update_attributes(request_params)
    if new_request == true
      AdminMailer.submit_request_for_tender(request_for_tender).deliver_now
    end
    render_wizard request_for_tender,
                  notice: 'Your request for tender has been submitted, it ' \
                          'will take at most 24 hours before it becomes ' \
                          'accessible publicly'
  end

  def save_the_changes(request_for_tender, stay=false)
    request_for_tender.status = step.to_s
    request_for_tender.update_attributes(request_params)
    if stay
      render_wizard nil, notice: 'Your changes have been saved!'
    else
      render_wizard request_for_tender, notice: 'Your changes have been saved!'
    end
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
                  :tender_figure_address,
                  list_of_items: [
                    :updated_at,
                    items: %i[name description quantity unit isHeader]
                  ],
                  project_documents_attributes: %i[id
                                                   document
                                                   _destroy],
                  required_documents_attributes: %i[id
                                                    title
                                                    _destroy])
  end
end
