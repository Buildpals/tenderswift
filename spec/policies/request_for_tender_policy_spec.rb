require 'rails_helper'

RSpec.describe RequestForTenderPolicy do
  subject { described_class.new(quantity_surveyor, request_for_tender) }

  let(:resolved_scope) do
    described_class::Scope.new(quantity_surveyor, RequestForTender).resolve
  end

  context 'being an owner of request_for_tender' do
    let(:quantity_surveyor) { QuantitySurveyor.new(id: 1) }
    let(:request_for_tender) { RequestForTender.create(quantity_surveyor_id: 1) }

    # it 'includes request_for_tender in resolved scope' do
    #   a = resolved_scope
    #   expect(a).to include(request_for_tender)
    # end

    it { is_expected.to permit_action(:show) }
  end

  context 'not being an owner of request_for_tender' do
    let(:quantity_surveyor) { QuantitySurveyor.new(id: 1) }
    let(:request_for_tender) { RequestForTender.create(quantity_surveyor_id: 2) }


    # it 'includes request_for_tender in resolved scope' do
    #   expect(resolved_scope).not_to include(request_for_tender)
    # end

    it { is_expected.not_to permit_action(:show) }
  end
end
