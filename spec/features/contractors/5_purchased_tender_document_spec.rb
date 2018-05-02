# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Purchased tender document' do
  include RequestForTendersHelper

  let(:purchased_tender_document) { FactoryBot.create(:purchased_tender) }

  background do
    login_as(purchased_tender_document.contractor, scope: :contractor)
  end

  scenario 'should show a contractor the general information of their purchased tender document' do
    visit tenders_project_information_path(purchased_tender_document)

    contractor_should_see_project_information
  end

  scenario 'should show a contractor the tender documents of their purchased tender document' do
    visit tenders_tender_documents_path(purchased_tender_document)
    contractor_should_see_tender_documents
  end

  scenario 'should show a contractor the bill of quantities of their purchased tender document' do
    visit tenders_boq_path(purchased_tender_document)
    contractor_should_see_bill_of_quantities
  end

  scenario 'should upload the required documents of a contractor\'s purchased tender document' do
    visit tenders_contractors_documents_path(purchased_tender_document)
    attach_file 'tender_required_document_uploads_attributes_0_document', 'spec/fixtures/upload_file.pdf'
    click_button 'Add', match: :first
    expect(page).to have_link 'View'
    # TODO: check that url is correct
  end

  scenario 'should upload other documents of a contractor\'s purchased tender document', js: true do
    skip 'Spec not finished'

    visit tenders_contractors_documents_path(purchased_tender_document)

    click_link 'Add another document'

    within :css, '#required-documents' do
      puts page.body

      find(:xpath, "//input[@type='text']").set('Company Portfolio')
      find(:xpath, "//input[@type='file']").set('Company Portfolio')


      # attach_file 'input[type="file"]', 'spec/fixtures/upload_file.pdf'

      puts page.body

      click_button 'Add'
    end

    expect(page).to have_link 'View'
    # TODO: check that url is correct
  end

  scenario 'should allow a contractor to fill and submit their purchased tender document' do
    skip 'Spec not finished'
    visit tenders_boq_path(purchased_tender_document)
  end

  scenario 'should allow a contractor to see the tendering results of their purchased tender document' do
    skip 'Not implemented'
    visit tenders_results_path(purchased_tender_document)
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

    purchased_tender_document.required_documents.each do |required_document|
      expect(page).to have_content required_document.title
    end

    expect(page).to have_content purchased_tender_document.tender_instructions
  end

  def contractor_should_see_tender_documents
    purchased_tender_document.project_documents.each do |project_document|
      expect(page).to have_content project_document.document.file.filename
      expect(page).to have_link 'Download', href: project_document.document.url
    end
  end

  def contractor_should_see_bill_of_quantities
    # expect(page).to have_content 'Item Description Q\'ty Unit Rate Amount'
    expect(page.find('rate-filling-boq')[':workbook-data'])
      .to eq(purchased_tender_document.workbook)
  end
end
