# frozen_string_literal: true

require 'sinatra/base'
require 'capybara_discoball'
require 'httparty'

class FakeKorbaWeb < Sinatra::Base
  post '/api/v1.0/collect/' do
    request.body.rewind
    request_payload = JSON.parse request.body.read

    if request_payload['customer_number'] == ''
      {
        error_code: 400,
        error_message: 'Please provide the customer_number value'
      }.to_json
    elsif request_payload['transaction_id'] == ''
      {
        error_code: 401,
        error_message: 'Please provide the transaction_id value'
      }.to_json
    elsif request_payload['amount'] == ''
      {
        error_code: 402,
        error_message: 'Please provide the amount value'
      }.to_json
    elsif !%w[VOD MTN TIG AIR].include?(request_payload['network_code'])
      {
        error_code: 405,
        error_message: 'Invalid network Code'
      }.to_json
    elsif request_payload['vodafone_voucher_code'] == ''
      {
        error_code: 406,
        error_message: 'Vodafone has been selected. Please provide the ' \
                         'vodafone_voucher_code value'
      }.to_json
    elsif request_payload['amount'].to_f < 0
      {
        error_code: 409,
        error_message: 'Invalid amount'
      }.to_json
    elsif request_payload['customer_number'].length != 10 ||
          /^(?<num>\d+)$/ !~ request_payload['customer_number']
      {
        error_code: 410,
        error_message: 'Invalid Customer Number format. Your number ' \
                         'must be 10 digits and must be entered in ' \
                         'the format 02xxxxxxxx'
      }.to_json
    else
      Thread.new do
        sleep(15)
        HTTParty.get(
          "#{request_payload['callback_url']}" \
          "?transaction_id=#{request_payload['transaction_id']}" \
          '&status=SUCCESS&message=hello'
        )
      end

      {
        success: true,
        results: 'Shit worked'
      }.to_json
    end
  end

  if app_file == $PROGRAM_NAME
    ENV['KORBA_WEB_BASE_URL'] = "http://localhost:#{settings.port}"
    run!
  end
end

Capybara::Discoball.spin(FakeKorbaWeb) do |server|
  ENV['KORBA_WEB_BASE_URL'] = "http://#{server.host}:#{server.port}"
  puts 'Started the FakeKorbaWeb server at: ' + ENV.fetch('KORBA_WEB_BASE_URL')
end
