# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OtherDocumentUploadPolicy do
  subject { described_class.new(quantity_surveyor, other_document_upload) }

  context 'quantity surveyor owns the request for tender for the ' \
          'other document upload' do
    let(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }
    let(:request_for_tender) { FactoryBot.create(:request_for_tender,
                                                 quantity_surveyor: quantity_surveyor) }
    let(:tender) { FactoryBot.create(:tender,
                                     request_for_tender: request_for_tender) }
    let(:other_document_upload) { FactoryBot.create(:other_document_upload,
                                                    tender: tender) }


    it { is_expected.to permit_action(:pdf_viewer) }
    it { is_expected.to permit_action(:image_viewer) }
    it { is_expected.to permit_action(:update) }


  end

  context 'quantity surveyor does not own the request for tender for the ' \
          'other document upload' do
    let(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }
    let(:request_for_tender) { FactoryBot.create(:request_for_tender) }
    let(:tender) { FactoryBot.create(:tender,
                                     request_for_tender: request_for_tender) }
    let(:other_document_upload) { FactoryBot.create(:other_document_upload,
                                                    tender: tender) }


    it { is_expected.to forbid_action(:pdf_viewer) }
    it { is_expected.to forbid_action(:image_viewer) }
    it { is_expected.to forbid_action(:update) }

  end
end
