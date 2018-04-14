# frozen_string_literal: true

module TenderTransactionsHelper
  def extract_payload(tender_transaction_params, request_for_tender_id)
    payload = {}
    tender_transaction_params.each do |k, v|
      unless k.eql?('tender_id') || k.eql?('request_for_tender_id')
        payload[k] = v
      end
    end
    current_time = Time.new
    current_time = current_time.to_i
    payload['transaction_id'] = current_time
    payload['callback_url'] = TenderTransaction.call_back_url
    payload['client_id'] = TenderTransaction.client_id
    payload['description'] = TenderTransaction.description
    payload['status'] = 'pending'
    payload['amount'] = RequestForTender.find(request_for_tender_id).selling_price
    payload.sort_by { |x, _y| x }.to_h
  end

  def get_json_document(payload)
    JSON.generate(payload)
  end

  def hmac_auth(json_document)
    ruby_hash_representation = JSON.parse(json_document)
    message = TenderTransaction.create_message(ruby_hash_representation)
    TenderTransaction.auth_signature(message)
  end

  def format_price(selling_price)
    format('%.2f', selling_price)
  end
end
