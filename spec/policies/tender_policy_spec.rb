# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TenderPolicy do
  subject { described_class.new(contractor, tender) }

  let(:quantity_surveyor) { FactoryBot.build(:quantity_surveyor) }
  let(:request_for_tender) { FactoryBot.build(:request_for_tender) }
  let(:contractor) { FactoryBot.build(:contractor) }

  context 'contractor owns a purchased tender' do
    let(:tender) { FactoryBot.build(:purchased_tender, contractor: contractor) }
    it { is_expected.to permit_action(:project_information) }
    it { is_expected.to permit_action(:boq) }
    it { is_expected.to permit_action(:contractors_documents) }
    it { is_expected.to permit_action(:results) }
    it { is_expected.to permit_action(:save_rates) }
    it { is_expected.to permit_action(:save_contractors_documents) }
  end

  context 'contractor does not own a purchased tender' do
    let(:tender) { FactoryBot.build(:tender, contractor: contractor) }
    it { is_expected.to forbid_action(:boq) }
    it { is_expected.to forbid_action(:contractors_documents) }
    it { is_expected.to forbid_action(:results) }
    it { is_expected.to forbid_action(:save_rates) }
    it { is_expected.to forbid_action(:save_contractors_documents) }
  end

  subject { described_class.new(quantity_surveyor, tender) }

  let(:quantity_surveyor) { FactoryBot.build(:quantity_surveyor) }
  let(:contractor) { FactoryBot.build(:contractor) }

  context 'quantity surveyor owns a request for tender' do
    let(:request_for_tender) { FactoryBot.build(:request_for_tender,
                                                quantity_surveyor: quantity_surveyor) }
    let(:tender) { FactoryBot.build(:purchased_tender, contractor: contractor,
                                    request_for_tender: request_for_tender) }

    it { is_expected.to permit_action(:other_documents) }
    it { is_expected.to permit_action(:disqualify) }
    it { is_expected.to permit_action(:undo_disqualify) }
    it { is_expected.to permit_action(:rate) }
    it { is_expected.to permit_action(:required_documents) }
  end

  context 'quantity surveyor does not owns a request for tender' do
    let(:request_for_tender) { FactoryBot.build(:request_for_tender) }
    let(:tender) { FactoryBot.build(:purchased_tender, contractor: contractor,
                                    request_for_tender: request_for_tender) }
    it { is_expected.to forbid_action(:other_documents) }
    it { is_expected.to forbid_action(:disqualify) }
    it { is_expected.to forbid_action(:undo_disqualify) }
    it { is_expected.to forbid_action(:rate) }
    it { is_expected.to forbid_action(:required_documents) }
  end

end
