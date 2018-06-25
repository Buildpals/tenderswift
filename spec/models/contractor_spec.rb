# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contractor, type: :model do
  let(:tender) { FactoryBot.create(:tender) }

  describe 'Associations' do
    it { should have_many(:tenders).dependent(:destroy) }
    it { should have_many(:request_for_tenders) }
  end

  describe 'Mailers' do
    it 'should send invitation emails' do
      mail = ContractorMailer
             .request_for_tender_email(tender, tender.request_for_tender)
      expect { mail.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe 'Validations' do
    # it { should validate_presence_of(:company_name) }
    it { should validate_presence_of(:email) }
    it 'should validate uniqueness of emails'
    it 'should validate format of email'
    it { should validate_presence_of(:phone_number) }
  end
end
