# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contractor, type: :model do
  let!(:tender) { FactoryBot.create(:tender) }

  describe 'Associations' do
    it { should have_many(:tenders).dependent(:destroy) }
    it { should have_many(:request_for_tenders) }
  end

  describe 'Mailers' do
    it 'sends invitation email' do
      mail = ContractorMailer
             .request_for_tender_email(tender, tender.request_for_tender)
      expect { mail.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
