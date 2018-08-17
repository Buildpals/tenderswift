# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Purchased tender document' do
  include RequestForTendersHelper

  let(:contractor) { FactoryBot.create(:contractor) }

  let(:purchased_tender_document) do
    FactoryBot.create(:purchased_tender,
                      contractor: contractor)
  end

  let(:filled_tender_document) do
    FactoryBot.create(:filled_tender,
                      contractor: contractor)
  end

  let(:submitted_tender_document) do
    FactoryBot.create(:submitted_tender,
                      contractor: contractor)
  end

  background do
    login_as(contractor, scope: :contractor)
  end

  scenario 'should show a contractor the general information of ' \
           'their purchased tender document' do
    visit tender_build_path(purchased_tender_document, :general_information)

    contractor_should_see_project_information(purchased_tender_document.request_for_tender)
  end

  scenario 'should show a contractor the tender documents of ' \
           'their purchased tender document' do
    visit tender_build_path(purchased_tender_document, :tender_documents)
    contractor_should_see_tender_documents(purchased_tender_document)
  end

  scenario 'should allow a contractor to fill in the rates ' \
           'their purchased tender document', js: true do
    skip 'Spec not finished'
    visit tender_build_path(purchased_tender_document, :bill_of_quantities)
    page.all('.rate-field').each do |rate_field|
      rate_field.set 1
    end
    click_button 'Save'
    expect(page).to have_content 'All changes saved', wait: 10
    purchased_tender_document.reload
    expect(purchased_tender_document.list_of_rates['rates'])
      .to eq('1' => '1', '2' => '1', '3' => '1', '4' => '1', '6' => '1')
  end

  scenario 'should allow a contractor to upload the required documents of ' \
           'their purchased tender document', js: true do
    visit tender_build_path(purchased_tender_document, :upload_documents)

    purchased_tender_document.required_documents.each do |required_document|
      within :css, "#required_document-#{required_document.id}" do
        expect(page).to have_content required_document.title

        attach_file('Upload file',
                    Rails.root + 'spec/fixtures/upload_file.pdf',
                    visible: false)

        expect(page).to have_link required_document.title, wait: 10
      end
    end
  end

  scenario 'should allow a contractor to submit their ' \
           'purchased tender document' do
    visit tender_build_path(filled_tender_document, :upload_documents)

    click_button 'Submit your bid', match: :first
    expect(page).to have_current_path contractor_root_path

    within :css, '#submitted-tenders' do
      expect(page).to have_content filled_tender_document.project_name
    end
  end

  scenario 'should allow display missing rates error', js: true do
    visit tender_build_path(purchased_tender_document, :upload_documents)
    click_button 'Submit your bid', match: :first
    purchased_tender_document.request_for_tender.list_of_rates.each do |key, _value|
      expect(page).to have_content(" #{key} of the Bill of Quantities is required but has " \
                 'not been provided')
    end
  end

  scenario 'should display required document errors', js: true do
    visit tender_build_path(purchased_tender_document, :upload_documents)
    click_button 'Submit your bid', match: :first
    purchased_tender_document.required_document_uploads.each do |document|
      expect(page).to have_content(" #{document.title} is required but has
                                          not been uploaded")
    end
  end

  scenario 'submitted tenders should move to submitted tenders column',
           js: true do
    visit tender_build_path(filled_tender_document, :upload_documents)
    click_button 'Submit your bid'

    visit contractor_root_path
    within :css, '#submitted-tenders' do
      expect(page)
        .to have_content filled_tender_document.request_for_tender.project_name
    end
  end

  private

  def contractor_should_see_project_information(request_for_tender)
    user_sees_public_request_for_tender_information(request_for_tender)
  end

  def contractor_should_see_tender_documents(tender)
    tender.request_for_tender.project_documents.each do |project_document|
      expect(page).to have_link project_document.original_file_name,
                                href: project_document.document.url
    end
  end

  def contractor_should_see_bill_of_quantities
    expect(page).to have_content 'Item Description Quantity Unit Price/Rate ' \
                                 'Amount'
  end
end
