# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RequiredDocumentUploadPolicy do
  subject { described_class.new(quantity_surveyor, required_document_upload) }

  let(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }

  context 'quantity_surveyor does not own the required_document\s ' \
          'request_for_tender, the tender is not reviewable' do

    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender)
    end

    let(:tender) do
      FactoryBot.create(:tender,
                        request_for_tender: request_for_tender)
    end

    let(:required_document_upload) do
      FactoryBot.create(:required_document_upload,
                        tender: tender)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:approve) }
    it { is_expected.to forbid_action(:reject) }
  end

  context 'quantity_surveyor does not own the required_document\s ' \
          'request_for_tender, the tender is reviewable' do

    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        deadline: Time.current - 1.hours)
    end

    let(:tender) do
      FactoryBot.create(:tender,
                        request_for_tender: request_for_tender,
                        purchased_at: Time.current - 2.days,
                        submitted_at: Time.current - 1.days)
    end

    let(:required_document_upload) do
      FactoryBot.create(:required_document_upload,
                        tender: tender)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:approve) }
    it { is_expected.to forbid_action(:reject) }
  end

  context 'quantity_surveyor owns the required_document\s request_for_tender,' \
          ' the tender is not reviewable' do

    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        quantity_surveyor: quantity_surveyor)
    end

    let(:tender) do
      FactoryBot.create(:tender,
                        request_for_tender: request_for_tender)
    end

    let(:required_document_upload) do
      FactoryBot.create(:required_document_upload,
                        tender: tender)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:approve) }
    it { is_expected.to forbid_action(:reject) }
  end

  context 'quantity_surveyor owns the required_document\s request_for_tender,' \
          ' the tender is reviewable' do

    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        quantity_surveyor: quantity_surveyor,
                        deadline: Time.current - 1.hours)
    end

    let(:tender) do
      FactoryBot.create(:tender,
                        request_for_tender: request_for_tender,
                        purchased_at: Time.current - 2.days,
                        submitted_at: Time.current - 1.days)
    end

    let(:required_document_upload) do
      FactoryBot.create(:required_document_upload,
                        tender: tender)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:approve) }
    it { is_expected.to permit_action(:reject) }
  end
end
