require 'faraday'
class TenderTransaction < ApplicationRecord

  #xchange.korbaweb.com

  SECRET_KEY = 'c610c0b75f1711a1c392c6a5d823390ee31e8c0ba40b9f2778570b249fa2c958'.freeze

  CLIENT_KEY = '8e10dd4fd8bf4dc6efc76a4560d7b77a216ae4a9'.freeze

  URL = 'https://korbaxchange.herokuapp.com'.freeze

  CALLBACK_URL = 'https://buildpals-development.herokuapp.com/tender/transactions/complete_transaction/'.freeze

  CLIENT_ID = 15.freeze

  enum status: { pending: 0, success: 1, failed: 2 }

  belongs_to :participant

  belongs_to :request_for_tender

  def self.secret_key
    SECRET_KEY
  end

  def self.url
    URL
  end

  def self.call_back_url
    CALLBACK_URL
  end

  def self.client_id
    CLIENT_ID
  end

  def self.description
    'Payment of Tender'
  end

  def self.make_digest(secret_key, message)
    OpenSSL::HMAC.hexdigest('SHA256', secret_key, message)
  end

  def self.get_json_representation(hash_params)
    JSON.generate(hash_params)
  end

  def self.get_ruby_representation(json)
    JSON.parse(json)
  end

  def self.create_message(ruby_hash)
    message = ''
    n = 0
    ruby_hash.each do |k, v|
      if n.zero?
        message = message + k.to_s + '=' + v.to_s
      else
        message = message + '&' + k.to_s + '=' + v.to_s
      end
      n += 1
    end
    message
  end

  def self.auth_signature(message)
    digest = make_digest(SECRET_KEY, message)
    authorization = "HMAC #{CLIENT_KEY}:#{digest}"
    authorization
  end


  def self.make_payment(authorization, payload, customer_number,
                        amount, voucher_code = nil,
                        network_code, status, participant_id, request_for_tender_id,transaction_id)
    conn = set_up_faraday
    response = send_request_to_korbaweb(authorization, conn, payload)
    response_hash = turn_response_to_hash(response.body)
    puts response_hash
    if response_hash['success'] == true
      new_tender_transaction_id = create_tender_transaction(amount, customer_number, network_code, participant_id,
                                request_for_tender_id, status, transaction_id, voucher_code)
      if network_code.eql?('CRD')
        set_up_participant(new_tender_transaction_id)
        return response_hash['redirect_url']
      elsif !response_hash['results'].nil?
        if network_code.eql?('VOD')
          set_up_participant(new_tender_transaction_id)
        end
        return response_hash['results']
      else
        return response_hash['details']
      end
    else
      return response_hash['error_message']
    end
  end

  private

  def self.set_up_participant(new_tender_transaction_id)
    new_tender_transaction = TenderTransaction.find(new_tender_transaction_id)
    new_tender_transaction.participant.status = 'participating'
    if new_tender_transaction.private?
      new_tender_transaction.participant.interested_declaration_time = Time.new
    end
    new_tender_transaction.participant.rating = 0
    new_tender_transaction.participant.save!
    new_tender_transaction.status = 'success'
    new_tender_transaction.save!
  end

  def self.turn_response_to_hash (response_body)
    JSON.parse(response_body.gsub("'",'"').gsub('=>',':'))
  end

  def self.create_tender_transaction(amount, customer_number, network_code, participant_id,
                                    request_for_tender_id, status, transaction_id, voucher_code)
    tender_transaction = TenderTransaction.new(customer_number: customer_number,
                                               amount: amount, vodafone_voucher_code: voucher_code,
                                               network_code: network_code, status: status,
                                               participant_id: participant_id,
                                               transaction_id: transaction_id)
    tender_transaction.request_for_tender = RequestForTender.find(request_for_tender_id)
    tender_transaction.save
    tender_transaction.id
  end

  def self.send_request_to_korbaweb(authorization, conn, payload)
    response = conn.post do |req|
      req.url '/api/v1.0/collect/'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = authorization
      req.body = JSON.generate(payload)
    end
  end

  def self.set_up_faraday
    uri = URI.parse(self.url)
    if Rails.env.production?
      conn = Faraday.new(:url => url, :proxy => "http://ug2fv7zrmee9du:6m504-EjzXb_7ewayHAYRDlZtQ@us-east-static-04.quotaguard.com:9293")
    else
      conn = Faraday.new(:url => url)
    end
    conn
  end

end
