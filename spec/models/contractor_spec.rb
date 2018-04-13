# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contractor, type: :model do
  let!(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }
  let!(:request_for_tender) { FactoryBot.build(:request_for_tender) }
  let!(:tender) { FactoryBot.create(:tender) }

  describe 'Associations' do
    it { should have_many(:tenders).dependent(:destroy) }
    it { should have_many(:request_for_tenders) }
  end

  describe 'Contractor Mailer' do
    it 'sends invitation email' do
      expect { ContractorMailer.request_for_tender_email(tender, request_for_tender).deliver_now }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
