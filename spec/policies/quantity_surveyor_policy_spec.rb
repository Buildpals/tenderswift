# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuantitySurveyorPolicy do
  subject { described_class.new(quantity_surveyor, quantity_surveyor_profile) }

  let(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }

  context 'when a quantity_surveyor owns the quantity_surveyor profile' do
    let(:quantity_surveyor_profile) { quantity_surveyor }

    it { is_expected.to permit_action(:dashboard) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
  end

  context 'when a quantity_surveyor does not own the quantity_surveyor profile' do
    let(:quantity_surveyor_profile) { FactoryBot.create(:quantity_surveyor) }

    it { is_expected.to forbid_action(:dashboard) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:update) }
  end
end
