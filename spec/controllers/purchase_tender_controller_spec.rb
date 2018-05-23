# frozen_string_literal: true

require 'rails_helper'
require 'securerandom'

RSpec.describe PurchaseTenderController, type: :controller do
  let!(:tender) do
    FactoryBot.create(:tender,
                      amount: 1,
                      transaction_id: SecureRandom.uuid)
  end

  describe 'GET #complete_transaction' do
    it 'Logs Invalid transaction ids' do
      invalid_transaction_id = '65a94227-e619-4c50-9c9d-9558530dfef4'

      get :complete_transaction,
          params: { transaction_id: invalid_transaction_id,
                    status: 'SUCCESS',
                    message: 'I was here som' }

      expect(Rails.logger)
        .to receive(:warn)
        .with("Invalid transaction_id: #{invalid_transaction_id}")
    end

    it 'Saves failed transactions' do
      get :complete_transaction,
          params: { transaction_id: tender.transaction_id,
                    status: 'FAILED',
                    message: 'Voucher invalid' }

      tender.reload
      expect(tender.purchase_request_status).to eq('failed')
      expect(tender.purchase_request_message).to eq('Voucher invalid')
    end

    it 'Saves successful transactions and delivers purchase success email' do
      get :complete_transaction,
          params: { transaction_id: tender.transaction_id,
                    status: 'SUCCESS',
                    message: 'I was here som' }

      tender.reload
      expect(tender.purchase_request_status).to eq('success')
      expect(tender.purchase_request_message).to eq('I was here som')

      mail = ActionMailer::Base.deliveries.last
      expect(mail.from).to eq(['projects@buildpals.com'])
      expect(mail.to).to eq([tender.contractors_email])
      expect(mail.subject).to eq('Successful purchase of tender documents')

      # TODO: Much more specific expectation of that particular tender
    end
  end
end
