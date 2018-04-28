# frozen_string_literal: true

class KorbaWeb
  # TODO: Move these into environmental variables via figaro
  SECRET_KEY =
    'c610c0b75f1711a1c392c6a5d823390ee31e8c0ba40b9f2778570b249fa2c958'

  CLIENT_KEY = '8e10dd4fd8bf4dc6efc76a4560d7b77a216ae4a9'

  CLIENT_ID = 15

  URL = 'https://korbaxchange.herokuapp.com'

  PROXY_URL = 'http://cyodkufnwbjy91:HN5Nhvd1h34IuipMXYzDQ_07Bg@us-east-static-04.quotaguard.com:9293'

  CALLBACK_URL = 'https://app.tenderswift.com/purchase_tender/complete_transaction'

  def initialize(payload)
    @payload = payload
  end

  def self.build(transaction_params)
    KorbaWeb.new(
      customer_number: transaction_params[:customer_number],
      amount: transaction_params[:amount],
      transaction_id: transaction_params[:transaction_id],
      client_id: CLIENT_ID,
      network_code: transaction_params[:network_code],
      callback_url: CALLBACK_URL,
      description: transaction_params[:description],
      vodafone_voucher_code: transaction_params[:vodafone_voucher_code]
    )
  end

  def call
    send_request_to_korba_web(@payload)
  end

  private

  def send_request_to_korba_web(payload)
    json_document = JSON.generate(payload)
    authorization_string = hmac_auth(json_document)

    # TODO: Handle connection errors
    response = faraday_connection.post do |req|
      req.url '/api/v1.0/collect/'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = authorization_string
      req.body = json_document
    end

    response_as_hash(response.body)
  end

  def faraday_connection
    if Rails.env.production?
      Faraday.new(url: URL, proxy: PROXY_URL)
    else
      Faraday.new(url: URL)
    end
  end

  def hmac_auth(json_document)
    ruby_hash_representation = JSON.parse(json_document)
    message = message(ruby_hash_representation)
    auth_signature(message)
  end

  def response_as_hash(response)
    if response['success']
      OpenStruct.new(success?: true,
                     redirect_url: response['redirect_url'],
                     results: response['results'])
    else
      OpenStruct.new(success?: false,
                     error_code: response['error_code'],
                     error_message: response['error_message'])
    end
  end

  def message(hash)
    hash.sort
        .map { |key, value| "#{key}=#{value}" }
        .join('&')
  end

  def auth_signature(message)
    digest = OpenSSL::HMAC.hexdigest('SHA256', SECRET_KEY, message)
    "HMAC #{CLIENT_KEY}:#{digest}"
  end
end
