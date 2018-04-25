# frozen_string_literal: true

class PurchaseTenderController < ContractorsController
  before_action :set_request_for_tender, only: %i[
    portal
    signup_and_purchase
    login_and_purchase
    purchase
  ]

  skip_before_action :authenticate_contractor!, only: %i[
    portal
    signup_and_purchase
    login_and_purchase
  ]

  layout 'contractors'

  def portal
    @contractor = Contractor.new
    increment_visit_count
  end

  def signup_and_purchase
    @contractor = Contractor.create_and_purchase(@request_for_tender,
                                                 signup_params,
                                                 signup_payment_params)
    if @contractor.save
      sign_in_and_redirect @contractor,
                           notice: 'You have purchased this tender successfully'
    else
      render 'portal', alert: 'There was an error purchasing the tender'
    end
  end

  def login_and_purchase
    @contractor = Contractor.validate_and_purchase(@request_for_tender,
                                                   login_params,
                                                   login_payment_params)
    if @contractor&.save
      sign_in_and_redirect @contractor,
                           notice: 'You have purchased this tender successfully'
    else
      render 'portal', alert: 'There was an error purchasing the tender'
    end
  end

  def purchase
    @purchase = TenderPurchaser.new(contractor: current_contractor,
                                    request_for_tender: @request_for_tender,
                                    phone_number: payment_params[:phone_number],
                                    network_code: payment_params[:network_code],
                                    voucher_code: payment_params[:vodafone_voucher_code])
                               .purchase
    if @purchase.success?
      render 'monitor_purchase', locals: { tender: @purchase.tender }
    else
      # TODO: Put more expressive error handling here
      render js: "alert('There was an error purchasing your tender')"
    end
  end

  def monitor_purchase
    @tender = Tender.find(params[:id])

    if @tender&.payment_confirmed?
      flash[:notice] = 'You have purchased this tender successfully'
      flash.keep(:notice) # Keep flash notice around for the redirect.
      render js: "window.location = '#{contractor_root_path}'"
    else
      render 'monitor_purchase', locals: { tender: @tender }
    end
  end

  private

  def increment_visit_count
    cookie_name = "request-for-tender-#{@request_for_tender.id}"
    return if cookies[cookie_name]

    @request_for_tender.portal_visits += 1
    @request_for_tender.save!
    cookies.permanent[cookie_name] = 'visited'
  end

  def set_request_for_tender
    @request_for_tender = RequestForTender.find(params[:id])
  end

  def signup_params
    params.require(:signup)
          .permit(:company_name,
                  :phone_number,
                  :email,
                  :password)
  end

  def login_params
    params.require(:login)
          .permit(:email,
                  :password)
  end

  def signup_payment_params
    params.require(:signup)
          .permit(:network_code,
                  :customer_number,
                  :vodafone_voucher_code)
  end

  def login_payment_params
    params.require(:login)
          .permit(:network_code,
                  :customer_number,
                  :vodafone_voucher_code)
  end

  def payment_params
    params.permit(:network_code,
                  :customer_number,
                  :vodafone_voucher_code)
  end
end
