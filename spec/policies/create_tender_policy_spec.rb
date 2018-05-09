# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateTenderPolicy do
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

    it 'includes request_for_tender in resolved scope' do
      expect(resolved_scope).to include(request_for_tender)
    end

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
    it { is_expected.to permit_action(:edit_tender_contractors) }
    it { is_expected.to permit_action(:update_tender_contractors) }
  end

  context 'quantity_surveyor does not own the request_for_tender' do
    let(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }
    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender)
    end


    it 'excludes request_for_tender from resolved scope' do
      expect(resolved_scope).not_to include(request_for_tender)
    end

    it { is_expected.to forbid_action(:edit_tender_information) }
    it { is_expected.to forbid_action(:update_tender_information) }
    it { is_expected.to forbid_action(:edit_tender_boq) }
    it { is_expected.to forbid_action(:update_tender_boq) }
    it { is_expected.to forbid_action(:update_contract_sum_address) }
    it { is_expected.to forbid_action(:edit_tender_documents) }
    it { is_expected.to forbid_action(:update_tender_documents) }
    it { is_expected.to forbid_action(:edit_tender_required_documents) }
    it { is_expected.to forbid_action(:update_tender_required_documents) }
    it { is_expected.to forbid_action(:edit_tender_payment_method) }
    it { is_expected.to forbid_action(:update_tender_payment_method) }
    it { is_expected.to forbid_action(:update_payment_details) }
    it { is_expected.to forbid_action(:edit_tender_contractors) }
    it { is_expected.to forbid_action(:update_tender_contractors) }
  end
end
