# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BuildRequestForTenderPolicy do
  subject { described_class.new(quantity_surveyor, request_for_tender) }

  let(:resolved_scope) do
    described_class::Scope.new(quantity_surveyor, RequestForTender.all).resolve
  end

  context 'quantity_surveyor owns the request_for_tender' do
    let(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }
    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        quantity_surveyor: quantity_surveyor)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:create) }
  end

  context 'quantity_surveyor does not own the request_for_tender' do
    let(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }
    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:create) }
  end
end
