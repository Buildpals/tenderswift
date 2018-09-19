# frozen_string_literal: true

class PurchaseTenderController < ContractorsController
  before_action :set_request_for_tender, except: :complete_transaction

  before_action :set_policy

  skip_before_action :authenticate_contractor!

  def portal
    authorize @request_for_tender

    tender = Tender.find_by(request_for_tender: @request_for_tender,
                            contractor: current_contractor)
    if tender&.purchased?
      redirect_to contractor_root_path,
                  notice: 'You have already purchased this tender'
    else
      increment_visit_count
    end
  end

  def payment
    #authorize @request_for_tender
    puts params.inspect
    # contractor is not signed in
    if current_contractor.nil?
      contractor = Contractor.find_by(email: params[:email])
      if contractor.nil?
        contractor = create_contractor
        sign_in(:contractor, contractor)
      end
      payload = { 'SECKEY': 'FLWSECK-85f9be41b757f9267f1322c70cb95eeb-X' ,
                  'txref': params[:txtref] }
      json = payload.to_json
      puts json
      connection = Faraday.new('https://ravesandboxapi.flutterwave.com/flwv3-pug/getpaidx/api/v2/verify')
      response = connection.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = json
      end
      puts response.body.class
      response = ActiveSupport::JSON.decode(response.body)
      response_charge_code = response['data']['chargecode']
      purchase_request_status = response['data']['status']
      if response_charge_code == '00' || response_charge_code == '0'
        Tender.create(request_for_tender: @request_for_tender,
                      customer_number: params[:customer_number],
                      amount: @request_for_tender.selling_price,
                      transaction_id: params[:txtref],
                      purchased_at: Time.now,
                      purchase_request_status: purchase_request_status,
                      contractor: contractor)
      end
      if @request_for_tender.selling_price == 0
        flash[:notice] = 'Welcome. Please fill in the' \
                         'information below, then you can start bidding'
      else
        flash[:notice] = 'You have purchased this tender successfully'
      end
      flash.keep(:notice) # Keep flash notice around for the redirect.
      sign_out(contractor)
      sign_in(:contractor, contractor)
      redirect_to contractor_root_path
    else
      # contractor has signed in
      payload = { 'SECKEY': 'FLWSECK-85f9be41b757f9267f1322c70cb95eeb-X' ,
                  'txref': params[:txtref] }
      json = payload.to_json
      connection = Faraday.new('https://ravesandboxapi.flutterwave.com/flwv3-pug/getpaidx/api/v2/verify')
      response = connection.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = json
      end
      puts response.body.inspect
      response = ActiveSupport::JSON.decode(response.body)
      response_charge_code = response['data']['chargecode']
      amount = response['data']['amount']
      purchase_request_status = response['data']['status']
      if response_charge_code == '00' || response_charge_code == '0'
        Tender.create(request_for_tender: @request_for_tender,
                      customer_number: params[:customer_number],
                      amount: @request_for_tender.selling_price,
                      transaction_id: params[:txtref],
                      purchase_request_status: purchase_request_status,
                      purchased_at: Time.now,
                      contractor: current_contractor)
      end
      if @request_for_tender.selling_price == 0
        flash[:notice] = 'Welcome. Please fill in the' \
                         'information below, then you can start bidding'
      else
        flash[:notice] = 'You have purchased this tender successfully'
      end
      flash.keep(:notice) # Keep flash notice around for the redirect.
      redirect_to contractor_root_path
    end
  end

  def purchase
    authorize @request_for_tender

    if current_contractor.nil?
      contractor = Contractor.find_by(email: params[:email])
      if contractor.nil?
        contractor = create_contractor
        sign_in(:contractor, contractor)
      elsif params[:password].blank?
        render 'blank_password'
        return
      elsif contractor.valid_password?(params[:password])
        sign_in(:contractor, contractor)
      else
        render 'wrong_password'
        return
      end
    end

    @purchaser = RequestForTenderPurchaser.build(
      contractor: current_contractor,
      request_for_tender: @request_for_tender
    )
    if @purchaser.purchase(payment_params)
      render 'monitor_purchase'
    else
      render 'purchase_tender_error'
    end
  end

  def monitor_purchase
    authorize @request_for_tender
      if @request_for_tender.selling_price == 0
        flash[:notice] = 'Welcome. Please fill in the' \
                         'information below, then you can start bidding'
      else
        flash[:notice] = 'You have purchased this tender successfully'
      end
      flash.keep(:notice) # Keep flash notice around for the redirect.
      render js: "window.location = '#{contractor_root_path}'"
  end

  def complete_transaction
    authorize :purchase_tender, :complete_transaction?

    @purchaser = RequestForTenderPurchaser.build(
      contractor: nil,
      request_for_tender: nil
    )

    @purchaser.complete_transaction(complete_transaction_params)
    head :no_content
  end

  private

  def set_policy
    RequestForTender.define_singleton_method(:policy_class) do
      PurchaseTenderPolicy
    end
  end

  def create_contractor
    generated_password = Devise.friendly_token.first(8)
    Contractor.create!(email: params[:email],
                       phone_number: params[:customer_number],
                       company_name: params[:company_name],
                       password: generated_password)
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
  rescue ActiveRecord::RecordNotFound
    redirect_to query_request_for_tender_path
  end

  def payment_params
    params.permit(:network_code, :customer_number, :vodafone_voucher_code,
                  :email, :company_name)
  end

  def complete_transaction_params
    params.permit(:transaction_id, :status, :message)
  end
end
