# frozen_string_literal: true

require 'rails_helper'
require 'securerandom'

RSpec.describe PurchaseTenderController, type: :controller do
  describe 'GET #portal' do
    let!(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        portal_visits: 0)
    end

    let!(:cookie_name) { "request-for-tender-#{request_for_tender.id}" }

    it 'renders portal and increments portal visits' do
      get :portal, params: { id: request_for_tender.id }

      expect(response.cookies[cookie_name]).to eq('visited')

      request_for_tender.reload
      expect(request_for_tender.portal_visits).to eq(1)

      expect(response).to render_template :portal
    end

    it 'renders portal and does not increments portal visits' do
      request.cookies[cookie_name] = 'visited'

      get :portal, params: { id: request_for_tender.id }

      request_for_tender.reload
      expect(request_for_tender.portal_visits).to eq(0)

      expect(response).to render_template :portal
    end

    it 'redirects to contractor dashboard if request_for_tender is purchased' do
      tender = FactoryBot.create(:tender,
                                 :purchased,
                                 request_for_tender: request_for_tender)

      sign_in tender.contractor, scope: :contractor

      get :portal, params: { id: request_for_tender.id }
      expect(response).to redirect_to contractor_root_path
    end
  end

  describe 'GET #purchase' do
    let!(:contractor) { FactoryBot.create(:contractor) }
    let!(:request_for_tender) { FactoryBot.create(:request_for_tender) }

    it 'renders monitor_purchase' do
      sign_in contractor, scope: :contractor

      get :purchase,
          params: { id: request_for_tender.id,
                    customer_number: '0500011505',
                    network_code: 'VOD',
                    vodafone_voucher_code: '123456' },
          xhr: true

      expect(response).to render_template :monitor_purchase
    end

    it 'renders purchase_tender_error' do
      sign_in contractor, scope: :contractor

      get :purchase,
          params: { id: request_for_tender.id,
                    network_code: 'VOD',
                    vodafone_voucher_code: '123456' },
          xhr: true

      expect(response).to render_template :purchase_tender_error
      # TODO: expect(response.body).to include('Please enter a phone number')
    end
  end

  describe 'GET #monitor_purchase' do
    let(:tender) { FactoryBot.create(:tender) }

    it 'renders monitor_purchase' do
      sign_in tender.contractor, scope: :contractor

      get :purchase,
          params: { id: tender.request_for_tender_id,
                    customer_number: '0500011505',
                    network_code: 'VOD',
                    vodafone_voucher_code: '123456' },
          xhr: true

      tender.reload

      get :monitor_purchase,
          params: { id: tender.request_for_tender_id },
          xhr: true

      expect(response).to render_template :monitor_purchase
    end

    it 'renders purchase_tender_error' do
      sign_in tender.contractor, scope: :contractor

      get :purchase,
          params: { id: tender.request_for_tender_id,
                    customer_number: '0500011505',
                    network_code: 'VOD',
                    vodafone_voucher_code: '123456' },
          xhr: true

      tender.reload

      get :complete_transaction,
          params: { transaction_id: tender.transaction_id,
                    status: 'FAILED',
                    message: 'Voucher invalid' }

      get :monitor_purchase,
          params: { id: tender.request_for_tender_id },
          xhr: true

      purchaser = assigns(:purchaser)
      expect(purchaser.error_message).to eq('Voucher invalid')
      expect(response).to render_template :purchase_tender_error
    end

    it 'renders relocation js' do
      sign_in tender.contractor, scope: :contractor

      get :purchase,
          params: { id: tender.request_for_tender_id,
                    customer_number: '0500011505',
                    network_code: 'VOD',
                    vodafone_voucher_code: '123456' },
          xhr: true

      tender.reload

      get :complete_transaction,
          params: { transaction_id: tender.transaction_id,
                    status: 'SUCCESS',
                    message: 'Transaction successful' }

      get :monitor_purchase,
          params: { id: tender.request_for_tender_id },
          xhr: true

      expect(response.body).to eq("window.location = '#{contractor_root_path}'")
    end
  end

  describe 'GET #complete_transaction' do
    let!(:tender) do
      FactoryBot.create(:tender,
                        amount: 1,
                        transaction_id: SecureRandom.uuid)
    end

    it 'Logs Invalid transaction ids' do
      invalid_transaction_id = '65a94227-e619-4c50-9c9d-9558530dfef4'

      get :complete_transaction,
          params: { transaction_id: invalid_transaction_id,
                    status: 'SUCCESS',
                    message: 'I was here som' }

      # expect(Rails.logger)
      #   .to receive(:warn)
      #   .with("Invalid transaction_id: #{invalid_transaction_id}")
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
