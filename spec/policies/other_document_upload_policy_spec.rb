# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OtherDocumentUploadPolicy do
  subject { described_class.new(publisher, other_document_upload) }

  let(:publisher) { FactoryBot.create(:publisher) }

  context 'publisher does not own the other_document\s ' \
          'request_for_tender, the tender is not reviewable' do

    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender)
    end

    let(:tender) do
      FactoryBot.create(:tender,
                        request_for_tender: request_for_tender)
    end

    let(:other_document_upload) do
      FactoryBot.create(:other_document_upload,
                        tender: tender)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:approve) }
    it { is_expected.to forbid_action(:reject) }
  end

  context 'publisher does not own the other_document\s ' \
          'request_for_tender, the tender is reviewable' do

    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        deadline: Time.current)
    end

    let(:tender) do
      FactoryBot.create(:tender,
                        :purchased,
                        :submitted,
                        request_for_tender: request_for_tender)
    end

    let(:other_document_upload) do
      FactoryBot.create(:other_document_upload,
                        tender: tender)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:approve) }
    it { is_expected.to forbid_action(:reject) }
  end

  context 'publisher owns the other_document\s request_for_tender,' \
          ' the tender is not reviewable' do

    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        publisher: publisher)
    end

    let(:tender) do
      FactoryBot.create(:tender,
                        request_for_tender: request_for_tender)
    end

    let(:other_document_upload) do
      FactoryBot.create(:other_document_upload,
                        tender: tender)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:approve) }
    it { is_expected.to forbid_action(:reject) }
  end

  context 'publisher owns the other_document\s request_for_tender,' \
          ' the tender is reviewable' do

    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        publisher: publisher,
                        deadline: Time.current)
    end

    let(:tender) do
      FactoryBot.create(:tender,
                        :purchased,
                        :submitted,
                        request_for_tender: request_for_tender)
    end

    let(:other_document_upload) do
      FactoryBot.create(:other_document_upload,
                        tender: tender)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:approve) }
    it { is_expected.to permit_action(:reject) }
  end
end
