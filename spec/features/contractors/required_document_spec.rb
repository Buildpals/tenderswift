# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'RequiredDocument', type: :feature do
  given(:purchased_tender) { FactoryBot.create(:purchased_tender) }
  given(:required_document) { RequiredDocument.create(title: 'Tax clearance certificate') }

  scenario 'Contractor should be able to upload a required document' do
    login_as(purchased_tender.contractor, scope: :contractor)
    purchased_tender.request_for_tender.required_documents << required_document
    purchased_tender.save!
    visit tenders_required_documents_url(purchased_tender)
    attach_file 'tender_required_document_uploads_attributes_0_document', 'spec/fixtures/files/upload_file.pdf'
    click_button "Save", match: :first
    expect(page).to have_link 'View'
    # TODO: check that url is correct
  end
end