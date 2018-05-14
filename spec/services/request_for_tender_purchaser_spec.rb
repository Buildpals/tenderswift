# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RequestForTenderPurchaser do

  let(:contractor) { FactoryBot.create(:contractor) }
  let(:request_for_tender) { FactoryBot.create(:request_for_tender) }
  # let(:korba_web_api) {}

  let(:purchaser) do
    RequestForTenderPurchaser.build(
        request_for_tender: request_for_tender,
        contractor: contractor
    )
  end

  it 'should return false when request_for_tender is not published' do
    request_for_tender = FactoryBot.create(:request_for_tender,
                                           published_at: nil)

    purchaser = RequestForTenderPurchaser.build(
        request_for_tender: request_for_tender,
        contractor: contractor
    )

    response = purchaser.purchase(customer_number: '0500011505',
                                  network_code: 'VOD',
                                  vodafone_voucher_code: '123456')

    expect(response).to be false
    expect(purchaser.error_message).to be 'The request for tender does not exist'
  end

  it 'should return false when request_for_tender is already purchased' do
    FactoryBot.create(:tender,
                      :purchased,
                      request_for_tender: request_for_tender,
                      contractor: contractor)

    response = purchaser.purchase(customer_number: '0500011505',
                                  network_code: 'VOD',
                                  vodafone_voucher_code: '123456')
    expect(response).to be false
    expect(purchaser.error_message).to be 'You have purchased this tender already'
  end

  it 'should return false when there is no phone number' do
    response = purchaser.purchase(customer_number: nil,
                                  network_code: 'VOD',
                                  vodafone_voucher_code: '123456')
    expect(response).to be false
    expect(purchaser.error_message).to be 'Please enter a phone number'

    response = purchaser.purchase(customer_number: '',
                                  network_code: 'VOD',
                                  vodafone_voucher_code: '123456')
    expect(response).to be false
    expect(purchaser.error_message).to be 'Please enter a phone number'
  end

  it 'should return false when phone number is invalid' do
    response = purchaser.purchase(customer_number: '500011505',
                                  network_code: 'VOD',
                                  vodafone_voucher_code: '123456')
    expect(response).to be false
    expect(purchaser.error_message).to be 'Please enter a valid phone number'
  end

  it 'should return false when network code is invalid' do
    response = purchaser.purchase(customer_number: '0500011505',
                                  network_code: 'AT&T',
                                  vodafone_voucher_code: '123456')
    expect(response).to be false
    expect(purchaser.error_message).to be 'Please select a network'
  end

  it 'should return false when there is no voucher code' do
    response = purchaser.purchase(customer_number: '0500011505',
                                  network_code: 'VOD',
                                  vodafone_voucher_code: nil)
    expect(response).to be false
    expect(purchaser.error_message).to be 'You have selected Vodafone, please enter a voucher code'

    response = purchaser.purchase(customer_number: '0500011505',
                                  network_code: 'VOD',
                                  vodafone_voucher_code: '')
    expect(response).to be false
    expect(purchaser.error_message).to be 'You have selected Vodafone, please enter a voucher code'
  end

  it 'should return success when all parameters are provided' do
    response = purchaser.purchase(customer_number: '0500011505',
                                  network_code: 'VOD',
                                  vodafone_voucher_code: '123456')

    expect(response).to be true
  end
end