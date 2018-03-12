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

    it { is_expected.to permit_action(:edit_tender_information) }
    it { is_expected.to permit_action(:update_tender_information) }
    it { is_expected.to permit_action(:edit_tender_boq) }
    it { is_expected.to permit_action(:update_tender_boq) }
    it { is_expected.to permit_action(:update_contract_sum_address) }
    it { is_expected.to permit_action(:edit_tender_documents) }
    it { is_expected.to permit_action(:update_tender_documents) }
    it { is_expected.to permit_action(:edit_tender_required_documents) }
    it { is_expected.to permit_action(:update_tender_required_documents) }
    it { is_expected.to permit_action(:edit_tender_payment_method) }
    it { is_expected.to permit_action(:update_tender_payment_method) }
    it { is_expected.to permit_action(:update_payment_details) }
    it { is_expected.to permit_action(:edit_tender_participants) }
    it { is_expected.to permit_action(:update_tender_participants) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:portal) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:compare_boq) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'not being an owner of request_for_tender' do
    let(:quantity_surveyor) { QuantitySurveyor.new(id: 1) }
    let(:request_for_tender) { RequestForTender.create(quantity_surveyor_id: 2) }

    # it 'includes request_for_tender in resolved scope' do
    #   expect(resolved_scope).not_to include(request_for_tender)
    # end

    it { is_expected.not_to permit_action(:edit_tender_information) }
    it { is_expected.not_to permit_action(:update_tender_information) }
    it { is_expected.not_to permit_action(:edit_tender_boq) }
    it { is_expected.not_to permit_action(:update_tender_boq) }
    it { is_expected.not_to permit_action(:update_contract_sum_address) }
    it { is_expected.not_to permit_action(:edit_tender_documents) }
    it { is_expected.not_to permit_action(:update_tender_documents) }
    it { is_expected.not_to permit_action(:edit_tender_required_documents) }
    it { is_expected.not_to permit_action(:update_tender_required_documents) }
    it { is_expected.not_to permit_action(:edit_tender_payment_method) }
    it { is_expected.not_to permit_action(:update_tender_payment_method) }
    it { is_expected.not_to permit_action(:update_payment_details) }
    it { is_expected.not_to permit_action(:edit_tender_participants) }
    it { is_expected.not_to permit_action(:update_tender_participants) }

    it { is_expected.not_to permit_action(:index) }
    it { is_expected.not_to permit_action(:show) }
    it { is_expected.not_to permit_action(:portal) }
    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:compare_boq) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:destroy) }
  end
end
