# frozen_string_literal: true

class RequestForTenders::BuildController < PublishersController
  include Wicked::Wizard

  before_action :set_policy
  before_action :set_request_for_tender, only: %i[show update]

  steps :general_information,
        :bill_of_quantities,
        :tender_documents,
        :tender_instructions,
        :distribution

  def show
    authorize @request_for_tender
    render_wizard
  end

  def update
    authorize @request_for_tender

    respond_to do |format|
      format.json do
        if @request_for_tender.update(request_for_tender_params)
          render json: @request_for_tender,
                 only: %i[id version_number],
                 status: :ok,
                 location: @request_for_tender
        else
          render json: @request_for_tender.errors,
                 status: :unprocessable_entity
        end
      end

      format.js do
        if step == steps.last && current_admin
          publish_the_request_for_tender(@request_for_tender)
        elsif step == steps.last
          submit_the_request_for_tender(@request_for_tender)
        else
          @request_for_tender.status = step.to_s
          @request_for_tender.update_attributes(request_for_tender_params)
          render_wizard @request_for_tender,
                        notice: 'Your changes have been saved!'
        end
      end
    end
  end

  def create
    @request_for_tender = current_publisher.request_for_tenders.new
    authorize @request_for_tender

    @request_for_tender.setup_with_data

    redirect_to wizard_path(steps.first,
                            request_for_tender_id: @request_for_tender.id)
  end

  private

  def publish_the_request_for_tender(request_for_tender)
    request_for_tender.published_at = Time.current
    request_for_tender.status = :active
    request_for_tender.update_attributes(request_for_tender_params)
    AdminMailer.publish_request_for_tender(request_for_tender).deliver_now
    render_wizard request_for_tender,
                  notice: 'The tender has been published successfully'
  end

  def submit_the_request_for_tender(request_for_tender)
    request_for_tender.submitted_at = Time.current
    request_for_tender.status = :active
    request_for_tender.update_attributes(request_for_tender_params)
    AdminMailer.submit_request_for_tender(request_for_tender).deliver_now
    render_wizard request_for_tender,
                  notice: 'Your request for tender has been submitted, it ' \
                          'will take at most 24 hours before it becomes ' \
                          'accessible publicly'
  end

  def set_policy
    RequestForTender.define_singleton_method(:policy_class) do
      BuildRequestForTenderPolicy
    end
  end

  def set_request_for_tender
    @request_for_tender = RequestForTender.find(params[:request_for_tender_id])
  end

  def finish_wizard_path
    publisher_root_path
  end

  def request_for_tender_params
    params.require(:request_for_tender)
          .permit(:project_name,
                  :contract_class,
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
                  :version_number,
                  :tender_currency,
                  list_of_rates: {},
                  project_documents_attributes: %i[id
                                                   document
                                                   _destroy],
                  required_documents_attributes: %i[id
                                                    title
                                                    _destroy])
  end
end
