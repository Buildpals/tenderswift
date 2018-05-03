# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContractorPolicy do
  subject { described_class.new(contractor, contractor_profile) }

  context 'when a contractor owns the contractor profile' do
    let(:contractor) { FactoryBot.create(:contractor) }
    let(:contractor_profile) { contractor }

    it { is_expected.to permit_action(:dashboard) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }

  end

  context 'when a contractor does not own the contractor profile' do
    let(:contractor) { FactoryBot.create(:contractor) }
    let(:contractor_profile) { FactoryBot.create(:contractor) }

    it { is_expected.to forbid_action(:dashboard) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:update) }

  end
end
