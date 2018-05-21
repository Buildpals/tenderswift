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

  def initialize
    @logger = Logger.new(STDOUT)
  end

  def call(transaction_params)
  send_request_to_korba_web(
      customer_number: transaction_params[:customer_number] || '',
      amount: transaction_params[:amount] || '',
      transaction_id: transaction_params[:transaction_id] || '',
      client_id: CLIENT_ID,
      network_code: transaction_params[:network_code] || '',
      callback_url: CALLBACK_URL,
      description: transaction_params[:description] || '',
      vodafone_voucher_code: transaction_params[:vodafone_voucher_code] || ''
  )
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

    process_response(response.body)
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

  def process_response(response)
    response = JSON.parse(response)
    if response['success']
      @logger.info(response)
      OpenStruct.new(success?: true,
                     redirect_url: response['redirect_url'],
                     results: response['results'])
    else
      @logger.warn(response)
      case response['error_code']
      when 400
        raise MissingCustomerNumberError, response['error_message']
      when 401, 411
        raise MissingTransactionIdError, response['error_message']
      when 402
        raise MissingAmountError, response['error_message']
      when 403
        raise MissingWalletCodeError, response['error_message']
      when 404
        raise MissingCallbackUrlError, response['error_message']
      when 405
        raise InvalidNetworkCodeError, response['error_message']
      when 406
        raise MissingVoucherCodeError, response['error_message']
      when 407
        raise DuplicateTransactionIdError, response['error_message']
      when 408
        raise InvalidCallbackUrlError, response['error_message']
      when 409
        raise InvalidAmountError, response['error_message']
      when 410
        raise InvalidCustomerNumberError, response['error_message']
      when 500
        raise KorbaWebInternalServerError, response['error_message']
      else
        raise KorbaWebError, response['error_message'] || response['detail']
      end
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

  class KorbaWebError < RuntimeError
  end

  class MissingCustomerNumberError < KorbaWebError
  end

  class MissingTransactionIdError < KorbaWebError
  end

  class MissingAmountError < KorbaWebError
  end

  class MissingWalletCodeError < KorbaWebError
  end

  class MissingCallbackUrlError < KorbaWebError
  end

  class InvalidNetworkCodeError < KorbaWebError
  end

  class MissingVoucherCodeError < KorbaWebError
  end

  class DuplicateTransactionIdError < KorbaWebError
  end

  class InvalidAmountError < KorbaWebError
  end

  class InvalidCallbackUrlError < KorbaWebError
  end

  class InvalidCustomerNumberError < KorbaWebError
  end

  class KorbaWebInternalServerError < KorbaWebError
  end

  class KorbaWebOffline < KorbaWebError
  end
end
