class CreateTenderController < ApplicationController
  before_action :set_request_for_tender, only: %i[edit_tender_information
                                                  edit_tender_documents
                                                  edit_tender_boq
                                                  edit_tender_required_documents
                                                  edit_tender_participants
                                                  edit_tender_payment_method
                                                  update_tender_information
                                                  update_tender_documents
                                                  update_tender_boq
                                                  update_contract_sum_address
                                                  update_tender_required_documents
                                                  update_tender_payment_method
                                                  update_tender_participants
                                                  update_payment_details]

  before_action :authenticate_quantity_surveyor!
  # before_action :check_if_published

  DEFAULT_BROADCAST_CONTENT = 'If you have any questions you can reply me here'.freeze

  def edit_tender_information
    @next_path = edit_tender_boq_path(@request_for_tender)
  end

  def update_tender_information
    if @request_for_tender.update(request_params)
      if params[:commit] == 'Next'
        redirect_to edit_tender_boq_path(@request_for_tender)
      else
        redirect_to edit_tender_information_path(@request_for_tender)
      end
    else
      render :edit_tender_information
    end
  end

  def edit_tender_boq
    @next_path = edit_tender_documents_path(@request_for_tender)
  end

  def update_tender_boq
    if @request_for_tender.update(request_params)
      if params[:commit] == 'Back'
        redirect_to edit_tender_information_path(@request_for_tender)
      elsif params[:commit] == 'Next'
        redirect_to edit_tender_documents_path(@request_for_tender)
      else
        redirect_to edit_tender_boq_path(@request_for_tender)
      end
    else
      render :edit_tender_boq
    end
  end

  def update_contract_sum_address
    if @request_for_tender.update(request_params)
      render json: @request_for_tender, status: :ok, location: @request_for_tender
    else
      render json: @request_for_tender.errors, status: :unprocessable_entity
    end
  end

  def edit_tender_documents
    @next_path = edit_tender_required_documents

    5.times { @request_for_tender.project_documents.build } if @request_for_tender.project_documents.empty?
  end

  def update_tender_documents
    if @request_for_tender.update(request_params)
      if params[:commit] == 'Back'
        redirect_to edit_tender_boq_path(@request_for_tender)
      elsif params[:commit] == 'Next'
        redirect_to edit_tender_required_documents_path(@request_for_tender)
      else
        redirect_to edit_tender_documents_path(@request_for_tender)
      end
    else
      render :edit_tender_documents
    end
  end

  def edit_tender_required_documents
    @next_path = edit_tender_payment_method_path(@request_for_tender)
  end

  def update_tender_required_documents
    if @request_for_tender.update(request_params)
      if params[:commit] == 'Back'
        redirect_to edit_tender_documents_path(@request_for_tender)
      elsif params[:commit] == 'Next'
        redirect_to edit_tender_payment_method_path(@request_for_tender)
      else
        redirect_to edit_tender_required_documents_path(@request_for_tender)
      end
    else
      render :edit_tender_required_documents
    end
  end

  def edit_tender_payment_method
    @next_path = edit_tender_participants_path(@request_for_tender)
  end

  def update_tender_payment_method
    if @request_for_tender.update(request_params)
      if params[:commit] == 'Back'
        redirect_to edit_tender_required_documents_path(@request_for_tender)
      elsif params[:commit] == 'Next'
        redirect_to edit_tender_participants_path(@request_for_tender)
      else
        redirect_to edit_tender_payment_method_path(@request_for_tender)
      end
    end
  end

  def update_payment_details
    # TODO: Consider moving this to the request_for_tenders controller
    # where it will be more apprioprate
    if @request_for_tender.update(request_params)
      redirect_to request_for_tender_path(@request_for_tender)
      flash[:notice] = 'Payment details has been changed successfully'
    else
      # TODO: Handle the errors for this action
      flash[:notice] = 'Payment details was not changed'
    end
  end

  def edit_tender_participants
    5.times { @request_for_tender.participants.build } if @request_for_tender.participants.empty?
  end

  def update_tender_participants
    if @request_for_tender.update(request_params)
      if params[:commit] == 'Back'
        redirect_to edit_tender_payment_method_path(@request_for_tender)
      elsif params[:commit] == 'Publish'
        if @request_for_tender.private?
          email_participants
        else
          @request_for_tender.update(published: true, published_time: Time.current)
          redirect_to request_for_tender_path
        end
      else
        redirect_to edit_tender_participants_path
      end
    else
      render :edit_tender_participants
    end
  end

  private

  def check_if_published
    if @request_for_tender.published?
      redirect_to request_for_tenders_path, notice: 'A tender cannot
                                          be edited once it\'s sent out
                                          to contractors'
    end
  end

  def email_participants
    if @request_for_tender.published?
      redirect_to @request_for_tender,
                  notice: 'The participants of this request have been contacted already'
    elsif @request_for_tender.participants.empty?
      redirect_to edit_tender_participants_path(@request_for_tender),
                  alert: 'You did not specify any participants for the request.'
    else
      send_emails_to_participants
      @request_for_tender.update(published: true, published_time: Time.current)
      redirect_to @request_for_tender, notice: 'An email has been sent to each participant of this request.'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_request_for_tender
    @request_for_tender = RequestForTender.find(params[:id])
    @participant = GuestParticipant.new(@request_for_tender)
    authorize @request_for_tender
  end

  def send_emails_to_participants
    @request_for_tender.participants.each do |participant|
      ParticipantMailer.request_for_tender_email(participant, @request_for_tender).deliver_later
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def request_params
    params.require(:request_for_tender)
          .permit(:project_name,
                  :deadline,
                  :city,
                  :description,
                  :country_code,
                  :currency,
                  :bill_of_quantities,
                  :tender_instructions,
                  :selling_price,
                  :withdrawal_frequency,
                  :bank_name,
                  :branch_name,
                  :account_name,
                  :account_number,
                  :private,
                  project_documents_attributes: %i[id
                                                   document
                                                   _destroy],
                  contract_sum_address: %i[sheet cellAddress],
                  participants_attributes: %i[id
                                              email
                                              phone_number
                                              company_name
                                              _destroy],
                  required_documents_attributes: %i[id
                                                    title
                                                    _destroy])
  end
end
