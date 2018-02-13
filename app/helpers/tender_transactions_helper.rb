module TenderTransactionsHelper

  def extract_payload (tender_transaction_params, request_for_tender_id)
    payload = {}
    tender_transaction_params.each { |k, v|
      unless k.eql?('participant_id') || k.eql?('request_for_tender_id')
        payload[k] = v
      end
    }
    current_time = Time.new
    current_time = current_time.to_i
    payload['transaction_id'] = current_time
    payload['callback_url'] = TenderTransaction.call_back_url
    payload['client_id'] = TenderTransaction.client_id
    payload['description'] = TenderTransaction.description
    payload['amount'] = RequestForTender.find(request_for_tender_id).selling_price
    payload = payload.sort_by{ |x, y| x}.to_h
    payload
  end

  def get_json_document(payload)
    json_document = JSON.generate(payload)
    json_document
  end

  def hmac_auth(json_document)
    ruby_hash_representation = JSON.parse(json_document)
    message = TenderTransaction.create_message(ruby_hash_representation)
    authorization = TenderTransaction.auth_signature(message)
    authorization
  end

end
