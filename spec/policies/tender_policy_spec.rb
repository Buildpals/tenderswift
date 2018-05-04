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
end
