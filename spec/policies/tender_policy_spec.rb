# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TenderPolicy do
  subject { described_class.new(contractor, tender) }

  let(:contractor) { FactoryBot.create(:contractor) }

  context 'contractor does not own the tender, ' \
          'the tender has not been purchased, ' \
          'the tender has not been submitted' do

    let(:tender) do
      FactoryBot.create(:tender)
    end

    it { is_expected.to forbid_action(:project_information) }
    it { is_expected.to forbid_action(:tender_documents) }
    it { is_expected.to forbid_action(:boq) }
    it { is_expected.to forbid_action(:contractors_documents) }
    it { is_expected.to forbid_action(:results) }
    it { is_expected.to forbid_action(:save_rates) }
    it { is_expected.to forbid_action(:save_contractors_documents) }
    it { is_expected.to forbid_action(:submit_tender) }
  end

  context 'contractor does not own the tender, ' \
          'the tender has not been purchased, ' \
          'the tender has been submitted' do
    let(:tender) do
      FactoryBot.create(:tender, :submitted)
    end

    it { is_expected.to forbid_action(:project_information) }
    it { is_expected.to forbid_action(:tender_documents) }
    it { is_expected.to forbid_action(:boq) }
    it { is_expected.to forbid_action(:contractors_documents) }
    it { is_expected.to forbid_action(:results) }
    it { is_expected.to forbid_action(:save_rates) }
    it { is_expected.to forbid_action(:save_contractors_documents) }
    it { is_expected.to forbid_action(:submit_tender) }
  end


  context 'contractor does not own the tender, ' \
          'the tender has been purchased, ' \
          'the tender has not been submitted' do
    let(:tender) do
      FactoryBot.create(:purchased_tender)
    end

    it { is_expected.to forbid_action(:project_information) }
    it { is_expected.to forbid_action(:tender_documents) }
    it { is_expected.to forbid_action(:boq) }
    it { is_expected.to forbid_action(:contractors_documents) }
    it { is_expected.to forbid_action(:results) }
    it { is_expected.to forbid_action(:save_rates) }
    it { is_expected.to forbid_action(:save_contractors_documents) }
    it { is_expected.to forbid_action(:submit_tender) }
  end

  context 'contractor does not own the tender, ' \
          'the tender has been purchased, ' \
          'the tender has been submitted' do
    let(:tender) do
      FactoryBot.create(:purchased_tender,
                        :submitted)
    end

    it { is_expected.to forbid_action(:project_information) }
    it { is_expected.to forbid_action(:tender_documents) }
    it { is_expected.to forbid_action(:boq) }
    it { is_expected.to forbid_action(:contractors_documents) }
    it { is_expected.to forbid_action(:results) }
    it { is_expected.to forbid_action(:save_rates) }
    it { is_expected.to forbid_action(:save_contractors_documents) }
    it { is_expected.to forbid_action(:submit_tender) }
  end


  context 'contractor owns the tender, ' \
          'the tender has not been purchased, ' \
          'the tender has not been submitted' do
    let(:tender) do
      FactoryBot.create(:tender,
                        contractor: contractor)
    end

    it { is_expected.to forbid_action(:project_information) }
    it { is_expected.to forbid_action(:tender_documents) }
    it { is_expected.to forbid_action(:boq) }
    it { is_expected.to forbid_action(:contractors_documents) }
    it { is_expected.to forbid_action(:results) }
    it { is_expected.to forbid_action(:save_rates) }
    it { is_expected.to forbid_action(:save_contractors_documents) }
    it { is_expected.to forbid_action(:submit_tender) }
  end

  context 'contractor owns the tender, ' \
          'the tender has not been purchased, ' \
          'the tender has been submitted' do
    let(:tender) do
      FactoryBot.create(:tender,
                        :submitted,
                        contractor: contractor)
    end

    it { is_expected.to forbid_action(:project_information) }
    it { is_expected.to forbid_action(:tender_documents) }
    it { is_expected.to forbid_action(:boq) }
    it { is_expected.to forbid_action(:contractors_documents) }
    it { is_expected.to forbid_action(:results) }
    it { is_expected.to forbid_action(:save_rates) }
    it { is_expected.to forbid_action(:save_contractors_documents) }
    it { is_expected.to forbid_action(:submit_tender) }
  end


  context 'contractor owns the tender, ' \
          'the tender has been purchased, ' \
          'the tender has not been submitted' do
    let(:tender) do
      FactoryBot.create(:purchased_tender,
                        contractor: contractor)
    end

    it { is_expected.to permit_action(:project_information) }
    it { is_expected.to permit_action(:tender_documents) }
    it { is_expected.to permit_action(:boq) }
    it { is_expected.to permit_action(:contractors_documents) }
    it { is_expected.to forbid_action(:results) }
    it { is_expected.to permit_action(:save_rates) }
    it { is_expected.to permit_action(:save_contractors_documents) }
    it { is_expected.to permit_action(:submit_tender) }
  end

  context 'contractor owns the tender, ' \
          'the tender has been purchased, ' \
          'the tender has been submitted' do
    let(:tender) do
      FactoryBot.create(:tender,
                        :purchased,
                        :submitted,
                        contractor: contractor)
    end

    it { is_expected.to permit_action(:project_information) }
    it { is_expected.to permit_action(:tender_documents) }
    it { is_expected.to permit_action(:boq) }
    it { is_expected.to permit_action(:contractors_documents) }
    it { is_expected.to permit_action(:results) }
    it { is_expected.to forbid_action(:save_rates) }
    it { is_expected.to forbid_action(:save_contractors_documents) }
    it { is_expected.to forbid_action(:submit_tender) }
  end

end
