# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Purchased tender document' do
  include RequestForTendersHelper

  let(:purchased_tender_document) { FactoryBot.create(:purchased_tender) }

  background do
    login_as(purchased_tender_document.contractor, scope: :contractor)
  end

  scenario 'A contractor can view  the general information of their purchased tender document' do
    visit tenders_project_information_path(purchased_tender_document)

    contractor_should_see_project_information
  end

  scenario 'A contractor can view the tender documents of their purchased tender document' do
    visit tenders_tender_documents_path(purchased_tender_document)
    contractor_should_see_tender_documents
  end

  scenario 'A contractor can view the bill of quantities of their purchased tender document' do
    visit tenders_boq_path(purchased_tender_document)
    contractor_should_see_bill_of_quantities
  end

  scenario 'A contractor can upload the required documents for their purchased tender document' do
    visit tenders_required_documents_path(purchased_tender_document)
    attach_file 'tender_required_document_uploads_attributes_0_document', 'spec/fixtures/upload_file.pdf'
    click_button 'Save', match: :first
    expect(page).to have_link 'View'
    # TODO: check that url is correct
  end

  scenario 'A contractor can upload other documents for their purchased tender document' do
    skip 'Spec not finished'
    visit tenders_required_documents_path(purchased_tender_document)
  end

  scenario 'A contractor can fill and submit their purchased tender document' do
    skip 'Spec not finished'
    visit tenders_boq_path(purchased_tender_document)
  end

  scenario 'A contractor can see the tendering results of their purchased tender document' do
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
    expect(page.find('rate-filling-boq')[':workbook-data'])
      .to eq(purchased_tender_document.workbook)
  end
end
