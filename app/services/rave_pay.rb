class RavePay

  SECRET_KEY = 'FLWSECK-85f9be41b757f9267f1322c70cb95eeb-X'

  PUBLIC_KEY = 'FLWPUBK-207b28f99def5b0533a3dd56d99ae748-X'

  TEST_URL = 'https://ravesandboxapi.flutterwave.com/flwv3-pug/getpaidx/api/v2/verify'

  LIVE_URL = 'https://api.ravepay.co/flwv3-pug/getpaidx/api/v2/verify'

  def initialize; end

  def call(txref)
    payload = { 'SECKEY': SECRET_KEY, 'txref': txref }
    json = payload.to_json
    ActiveSupport::JSON.decode(send_request_to_rave_pay(json))
  end

  private

  def send_request_to_rave_pay(payload)
    if Rails.env.development? || Rails.env.test?
      connection = Faraday.new(TEST_URL)
    else
      connection = Faraday.new(LIVE_URL)
    end
    response = connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = payload
    end
    response.body
  end
end