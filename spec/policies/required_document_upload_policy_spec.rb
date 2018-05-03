# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RequiredDocumentUploadPolicy do
  subject { described_class.new(quantity_surveyor, required_document_upload) }

  context 'quantity surveyor owns the request for tender for the ' \
          'required document upload' do
    let(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }
    let(:request_for_tender) { FactoryBot.create(:request_for_tender,
                                                 quantity_surveyor: quantity_surveyor) }
    let(:required_document) { FactoryBot.create(:required_document,
                                                request_for_tender:
                                                    request_for_tender)}
    let(:tender) { FactoryBot.create(:tender,
                                     request_for_tender: request_for_tender) }
    let(:required_document_upload) { FactoryBot.create(:required_document_upload,
                                                        tender: tender,
                                                        required_document:
                                                            required_document) }


    it { is_expected.to permit_action(:pdf_viewer) }
    it { is_expected.to permit_action(:image_viewer) }
    it { is_expected.to permit_action(:update) }


  end


  context 'quantity surveyor does not own the request for tender for the ' \
          'required document upload' do
    let(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }
    let(:request_for_tender) { FactoryBot.create(:request_for_tender) }
    let(:required_document) { FactoryBot.create(:required_document,
                                                request_for_tender:
                                                    request_for_tender)}
    let(:tender) { FactoryBot.create(:tender,
                                     request_for_tender: request_for_tender) }
    let(:required_document_upload) { FactoryBot.create(:required_document_upload,
                                                       tender: tender,
                                                       required_document:
                                                           required_document) }


    it { is_expected.to forbid_action(:pdf_viewer) }
    it { is_expected.to forbid_action(:image_viewer) }
    it { is_expected.to forbid_action(:update) }


  end
end
