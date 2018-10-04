# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublisherPolicy do
  subject { described_class.new(publisher, publisher_profile) }

  let(:publisher) { FactoryBot.create(:publisher) }

  context 'when a publisher owns the publisher profile' do
    let(:publisher_profile) { publisher }

    it { is_expected.to permit_action(:dashboard) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
  end

  context 'when a publisher does not own the publisher profile' do
    let(:publisher_profile) { FactoryBot.create(:publisher) }

    it { is_expected.to forbid_action(:dashboard) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:update) }
  end
end
