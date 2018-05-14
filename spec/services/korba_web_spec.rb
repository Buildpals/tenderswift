# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KorbaWeb do
  let(:korba_web) {KorbaWeb.new}

  it 'raises error when korba_web returns 400: Customer Number was not ' \
     'provided' do
    expect {
      korba_web.call(customer_number: nil,
                     amount: '100',
                     transaction_id: Time.current.to_s,
                     network_code: 'VOD',
                     vodafone_voucher_code: '12345',
                     description: 'Rspec test')
    }.to raise_error(KorbaWeb::MissingCustomerNumberError,
                     'Please provide the customer_number value')
  end

  it 'raises error when korba_web returns 401/411: Unique Transaction ID was ' \
     'not provided' do
    expect {
      korba_web.call(customer_number: '0500011505',
                     amount: '100',
                     transaction_id: nil,
                     network_code: 'VOD',
                     vodafone_voucher_code: '12345',
                     description: 'Rspec test')
    }.to raise_error(KorbaWeb::MissingTransactionIdError,
                     'Please provide the transaction_id value')
  end

  it 'raises error when korba_web returns 402: Amount was not provided' do
    expect {
      korba_web.call(customer_number: '0500011505',
                     amount: nil,
                     transaction_id: Time.current.to_s,
                     network_code: 'VOD',
                     vodafone_voucher_code: '12345',
                     description: 'Rspec test')
    }.to raise_error(KorbaWeb::MissingAmountError,
                     'Please provide the amount value')
  end

  it 'raises error when korba_web returns 403: Wallet Code was not provided' do
    skip 'Spec not implemented'
  end

  it 'raises error when korba_web returns 405: Invalid Network Code' do
    expect {
      korba_web.call(customer_number: '0500011505',
                     amount: '100',
                     transaction_id: Time.current.to_s,
                     network_code: 'AT&T',
                     vodafone_voucher_code: '12345',
                     description: 'Rspec test')
    }.to raise_error(KorbaWeb::InvalidNetworkCodeError, 'Invalid network Code')
  end

  it 'raises error when korba_web returns 406: Vodafone has been selected ' \
     'but voucher code not provided' do
    expect {
      korba_web.call(customer_number: '0500011505',
                     amount: '100',
                     transaction_id: Time.current.to_s,
                     network_code: 'VOD',
                     vodafone_voucher_code: nil,
                     description: 'Rspec test')
    }.to raise_error(
             KorbaWeb::MissingVoucherCodeError,
             'Vodafone has been selected. Please provide the vodafone_voucher_code value'
         )
  end

  it 'raises error when korba_web returns 407: Duplicate Transaction ID' do
    skip 'Spec not implemented'
  end

  it 'raises error when korba_web returns 409: Invalid amount' do
    expect {
      korba_web.call(customer_number: '0500011505',
                     amount: '-abc',
                     transaction_id: Time.current.to_s,
                     network_code: 'VOD',
                     vodafone_voucher_code: '12345',
                     description: 'Rspec test')
    }.to raise_error(KorbaWeb::InvalidAmountError, 'Invalid amount')
  end

  it 'raises error when korba_web returns 410: Invalid customer number ' \
     'format. Number must be 10 digits in the format 02xxxxxxxx' do
    expect {
      korba_web.call(customer_number: '500011505',
                     amount: '100',
                     transaction_id: Time.current.to_s,
                     network_code: 'VOD',
                     vodafone_voucher_code: '12345',
                     description: 'Rspec test')
    }.to raise_error(
             KorbaWeb::InvalidCustomerNumberError,
             'Invalid Customer Number format. Your number must be 10 digits and must be entered in the format 02xxxxxxxx')
  end

  it 'raises error when korba_web returns 500: We did something wrong' do
    skip 'Spec not implemented'
  end

  it 'raises error when korba_web throws internal server' do
    skip 'Spec not implemented'
  end

  it 'raises error when korba_web is offline' do
    skip 'Spec not implemented'
  end

  it 'returns success when all parameters are provided correctly' do
    response = korba_web.call(customer_number: '0500011505',
                              amount: '100',
                              transaction_id: Time.current.to_s,
                              network_code: 'VOD',
                              vodafone_voucher_code: '12345',
                              description: 'Rspec test')
    expect(response.success?).to be true
  end
end