# frozen_string_literal: true

class PurchaseTenderController < ContractorsController
  before_action :set_request_for_tender

  before_action :set_policy

  skip_before_action :authenticate_contractor!, only: %i[
    portal
    complete_transaction
  ]

  def portal
    tender = Tender.find_by(request_for_tender: @request_for_tender,
                            contractor: current_contractor)
    if tender&.purchased?
      redirect_to contractor_root_path,
                  notice: 'You have already purchased this tender'
    else
      increment_visit_count
    end
  end

  def purchase
    authorize(current_contractor.tender)

    @purchase = RequestForTenderPurchaser.new(
      contractor: current_contractor,
      request_for_tender: @request_for_tender
    )

    if @purchase.purchase(payment_params)
      render 'monitor_purchase'
    else
      render 'purchase_tender_error'
    end
  end

  def monitor_purchase
    authorize(current_contractor.tender)

    @purchase = RequestForTenderPurchaser.new(
      contractor: current_contractor,
      request_for_tender: @request_for_tender
    )

    if @purchase.payment_confirmed?
      flash[:notice] = 'You have purchased this tender successfully'
      flash.keep(:notice) # Keep flash notice around for the redirect.
      render js: "window.location = '#{contractor_root_path}'"
    else
      render 'monitor_purchase'
    end
  end

  def complete_transaction
    RequestForTenderPurchaser
      .complete_transaction(transaction_id: params['transaction_id'],
                            status: params['status'],
                            message: params['message'])
  end

  private

  def set_policy
    Tender.define_singleton_method(:policy_class) { PurchaseTenderPolicy }
  end

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

  def payment_params
    params.permit(:network_code,
                  :customer_number,
                  :vodafone_voucher_code)
  end
end
