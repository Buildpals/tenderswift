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

    contractor_should_see_project_information
  end

  scenario 'should show a contractor the tender documents of ' \
           'their purchased tender document' do
    visit tender_build_path(purchased_tender_document, :tender_documents)
    contractor_should_see_tender_documents
  end

  scenario 'should allow a contractor to fill in the rates ' \
           'their purchased tender document', js: true do
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

  scenario 'should allow a contractor to review their rates' \
           'after submission' do
    skip 'Spec not finished'
    visit tender_view_path(submitted_tender_document, :bill_of_quantities)

    page.all('.rate-field').each do |rate_field|
      expect(rate_field.value).to eq
    end
  end

  scenario 'should allow a contractor to review their required document' \
           'uploads after submission' do
    visit tender_view_path(submitted_tender_document, :upload_documents)

    submitted_tender_document.required_documents.each do |required_document|
      expect(page).to have_link required_document.title
    end
  end

  scenario 'should allow a contractor to see the tendering results of ' \
           'their purchased tender document', js: true do
    request_for_tender = FactoryBot.create(:request_for_tender)

    contractor1 = FactoryBot.create(:contractor)
    contractor2 = purchased_tender_document.contractor

    tender1 = FactoryBot.create(:tender,
                                :purchased,
                                :submitted,
                                contractor: contractor1,
                                request_for_tender: request_for_tender)

    tender2 = FactoryBot.create(:tender,
                                :purchased,
                                :submitted,
                                contractor: contractor2,
                                request_for_tender: request_for_tender)

    visit tender_view_path(tender2, :results)

    expect(page).to have_content contractor1.company_name
    expect(page).to have_content contractor2.company_name

    tender1.required_document_uploads.each do |document|
      expect(page).to have_content document.title
    end

    tender2.required_document_uploads.each do |document|
      expect(page).to have_content document.title
    end

    tender1.other_document_uploads.each do |document|
      expect(page).to have_content document.title
    end

    tender2.other_document_uploads.each do |document|
      expect(page).to have_content document.title
    end
  end

  private

  def contractor_should_see_project_information
    expect(page).to have_content purchased_tender_document.project_name
    expect(page).to have_content purchased_tender_document.project_owners_company_name
    expect(page).to have_content contract_class purchased_tender_document
    expect(page).to have_content project_location purchased_tender_document
    expect(page).to have_content project_currency purchased_tender_document

    expect(page).to have_content time_to_deadline purchased_tender_document
    expect(page).to have_content purchased_tender_document.deadline.to_formatted_s(:long)

    expect(page).to have_content purchased_tender_document.description

    purchased_tender_document
      .request_for_tender
      .required_documents.each do |required_document|
      expect(page).to have_content required_document.title
    end

    expect(page).to have_content purchased_tender_document.tender_instructions
  end

  def contractor_should_see_tender_documents
    purchased_tender_document.project_documents.each do |project_document|
      expect(page).to have_link project_document.original_file_name,
                                href: project_document.document.url
    end
  end

  def contractor_should_see_bill_of_quantities
    expect(page).to have_content 'Item Description Quantity Unit Price/Rate ' \
                                 'Amount'
  end
end
