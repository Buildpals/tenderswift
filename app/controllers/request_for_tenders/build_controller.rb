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
          publish_the_request_for_tender(@request_for_tender)
        else
          @request_for_tender.status = step.to_s
          @request_for_tender.update_attributes(request_for_tender_params)
          render_wizard @request_for_tender,
                        notice: 'Your changes have been saved!'
        end
      end
    end
  end

  def new
    @request_for_tender = current_publisher.request_for_tenders.new
    authorize @request_for_tender

    @request_for_tender.setup_with_data(request.location)

    redirect_to wizard_path(steps.first,
                            request_for_tender_id: @request_for_tender.id)
  end

  def create
    @request_for_tender = current_publisher.request_for_tenders.new
    authorize @request_for_tender

    @request_for_tender.setup_with_data(request.location)

    redirect_to wizard_path(steps.first,
                            request_for_tender_id: @request_for_tender.id)
  end

  private

  def publish_the_request_for_tender(request_for_tender)
    request_for_tender.published_at = Time.current
    request_for_tender.submitted_at = Time.current
    request_for_tender.status = :active
    request_for_tender.update_attributes(request_for_tender_params)
    AdminMailer.submit_request_for_tender(request_for_tender).deliver_now
    redirect_to publisher_root_path,
                  notice: "Your request for tender has been published. Share " \
                          "this link "\
                          "https://public.tenderswift.com/#{request_for_tender.id} " \
                          "with anyone you wish to submit a bid for this request"
  end

  def submit_the_request_for_tender(request_for_tender)
    request_for_tender.submitted_at = Time.current
    request_for_tender.published_at = Time.current
    request_for_tender.status = :active
    request_for_tender.update_attributes(request_for_tender_params)
    redirect_to(
        confirm_publishing_path(request_for_tender),
        notice: 'Your request for tender has been published. Share this link ' \
              "https://public.tenderswift.com/#{request_for_tender.id} " \
              'with anyone you wish to submit a bid for this request'
    )
  end

  def set_policy
    RequestForTender.define_singleton_method(:policy_class) do
      BuildRequestForTenderPolicy
    end
  end

  def set_request_for_tender
    @request_for_tender = RequestForTender.find(params[:request_for_tender_id])
  end

  def request_for_tender_params
    params.require(:request_for_tender)
          .permit(:project_name,
                  :deadline,
                  :city,
                  :description,
                  :country_code,
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
