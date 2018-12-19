# frozen_string_literal: true

class RequestForTenders::BuildController < PublishersController
  include Wicked::Wizard

  before_action :set_policy
  before_action :set_request_for_tender, only: %i[show update]

  before_action :stop_sample_request_for_tender_from_saving, only: :update

  steps :general_information,
        :bill_of_quantities,
        :tender_documents,
        :tender_instructions,
        :distribution

  def show
    authorize @request_for_tender
    @request_for_tender.participants.build
    @request_for_tender.participants.build
    @request_for_tender.participants.build
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
    if params[:sample].eql?('true') && current_publisher.request_for_tenders
                                           .count.eql?(0)
      @request_for_tender = current_publisher.request_for_tenders.new
      authorize @request_for_tender

      @request_for_tender.setup_sample_request_for_tender(request.location)

      redirect_to wizard_path(steps.first,
                              request_for_tender_id: @request_for_tender.id)
    else
      @request_for_tender = current_publisher.request_for_tenders.new
      authorize @request_for_tender

      @request_for_tender.setup_with_data(request.location)

      redirect_to wizard_path(steps.first,
                              request_for_tender_id: @request_for_tender.id)
    end
  end

  private

  def stop_sample_request_for_tender_from_saving
    if @request_for_tender.sample.eql?(true) && step != steps.last
      catch (:abort) {
        render_wizard @request_for_tender,
                      notice: 'Thank you for using Tenderswift!'
        throw :abort
      }
    end
  end


  def publish_the_request_for_tender(request_for_tender)
    request_for_tender.published_at = Time.current
    request_for_tender.submitted_at = Time.current
    request_for_tender.status = :active
    request_for_tender.update_attributes(request_for_tender_params)
    if request_for_tender.sample.equal?(true)
      setup_sample_contractor(request_for_tender)
      redirect_to request_for_tender_path(request_for_tender),
                  notice: "Thank you for using Tenderswift!"
    else
      AdminMailer.submit_request_for_tender(request_for_tender).deliver_now
      redirect_to request_for_tender_path(request_for_tender),
                  notice: "Your request for tender has been published. Share " \
                          "this link "\
                          "https://public.tenderswift.com/#{request_for_tender.id} " \
                          "with anyone you wish to submit a bid for this request"
    end
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

  def setup_sample_contractor(request_for_tender)

    if Contractor.find_by_email('john.doe@tenderswift.com').nil?
      first_contractor = Contractor.create(full_name: 'John Doe',
                                           company_name: 'Sample International Bidder',
                                           email: 'john.doe@tenderswift.com',
                                           phone_number: '0509825831',
                                           password: 'password', confirmed_at: Time.current,
                                           company_logo: 'http://res.cloudinary.com/tenderswift/image/upload/v1519220265/p0bjijzpbadcssih9j3n.png')
      second_contractor = Contractor.create(full_name: 'Sarah Jane',
                                            company_name: 'Sample Engineering',
                                            email: 'sarah.jane@tenderswift.com',
                                            phone_number: '0509825831',
                                            password: 'password', confirmed_at: Time.current,
                                            company_logo: 'http://res.cloudinary.com/tenderswift/image/upload/v1519220265/p0bjijzpbadcssih9j3n.png')
    else
      first_contractor = Contractor.find_by_email('john.doe@tenderswift.com')
      second_contractor = Contractor.find_by_email('sarah.jane@tenderswift.com')
    end

    first_tender = Tender.new(contractor: first_contractor,
                              request_for_tender: request_for_tender,
                              disqualified: false,
                              customer_number: first_contractor.phone_number,
                              transaction_id: 'xyz1234',
                              purchased_at: Time.now,
                              purchase_request_sent_at: Time.current - 2.hours,
                              amount: request_for_tender
                                          .selling_price_subunit,
                              purchase_request_status: 'successful',
                              list_of_rates:
                                  {'Sheet1!E8' => rand(2..3),
                                   'Sheet1!E11' => rand(21..22),
                                   'Sheet1!E14' => rand(17..18),
                                   'Sheet1!E17' => rand(79..81),
                                   'Sheet1!E20' => rand(14..16),
                                   'Sheet1!E22' => rand(12..14),
                                   'Sheet1!E26' => rand(64..66),
                                   'Sheet1!E35' => rand(430..460),
                                   'Sheet1!E41' => rand(500..550),
                                   'Sheet1!E57' => rand(3..4),
                                   'Sheet1!E66' => rand(7..8),
                                   'Sheet1!E70' => rand(18..20),
                                   'Sheet1!E86' => rand(49..51)})


    second_tender = Tender.new(contractor: second_contractor,
                               request_for_tender: request_for_tender,
                               disqualified: false,
                               customer_number: first_contractor.phone_number,
                               transaction_id: 'abcd1234',
                               purchased_at: Time.now,
                               purchase_request_sent_at: Time.current - 2.hours,
                               amount: request_for_tender
                                           .selling_price_subunit,
                               purchase_request_status: 'successful',
                               list_of_rates:
                                   {'Sheet1!E8' => rand(2..3),
                                    'Sheet1!E11' => rand(21..22),
                                    'Sheet1!E14' => rand(17..18),
                                    'Sheet1!E17' => rand(79..81),
                                    'Sheet1!E20' => rand(14..16),
                                    'Sheet1!E22' => rand(12..14),
                                    'Sheet1!E26' => rand(64..66),
                                    'Sheet1!E35' => rand(430..460),
                                    'Sheet1!E41' => rand(500..550),
                                    'Sheet1!E57' => rand(3..4),
                                    'Sheet1!E66' => rand(7..8),
                                    'Sheet1!E70' => rand(18..20),
                                    'Sheet1!E86' => rand(49..51)})

    first_tender.request_for_tender.required_documents.each do |document|
      RequiredDocumentUpload.create(tender: first_tender,
                                    document: File.new(Rails.root.join("app/uploaders/sample/upload_file.pdf")),
                                    required_document: document)
    end

    second_tender.request_for_tender.required_documents.each do |document|
      RequiredDocumentUpload.create(tender: second_tender,
                                    document: File.new(Rails.root.join("app/uploaders/sample/upload_file.pdf")),
                                    required_document: document)
    end

    first_tender.submitted_at = Time.now
    second_tender.submitted_at = Time.now
    first_tender.save!
    second_tender.save!
    request_for_tender.deadline = Time.now
    request_for_tender.save!

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
                  :access,
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
