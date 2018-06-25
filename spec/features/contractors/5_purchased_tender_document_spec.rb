# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Purchased tender document' do
  include RequestForTendersHelper

  let(:purchased_tender_document) { FactoryBot.create(:purchased_tender) }

  background do
    login_as(purchased_tender_document.contractor, scope: :contractor)
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
    skip 'Spec not finished'
    contractor_should_see_bill_of_quantities
  end

  scenario 'should allow a contractor to upload the required documents of ' \
           'their purchased tender document', js: true do
    visit tender_build_path(purchased_tender_document, :upload_documents)
    skip 'Not implemented'
    # attach_file 'tender_required_document_uploads_attributes_0_document', 'spec/fixtures/upload_file.pdf'
    # click_button 'Add', match: :first
    # expect(page).to have_link 'View'
    # TODO: check that url is correct
  end

  scenario 'should allow a contractor to submit their ' \
           'purchased tender document' do
    visit tender_build_path(purchased_tender_document, :bill_of_quantities)
    skip 'Not implemented'
    visit tender_build_path(purchased_tender_document, :upload_documents)
    skip 'Not implemented'
  end

  scenario 'should allow a contractor to review their ' \
           'purchased tender document after submission' do
    skip 'Not implemented'
  end

  scenario 'should allow a contractor to see the tendering results of ' \
           'their purchased tender document' do
    visit tender_view_path(purchased_tender_document, :results)
    skip 'Not implemented'
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
