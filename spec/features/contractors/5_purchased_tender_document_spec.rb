# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Purchased tender document' do
  include RequestForTendersHelper

  let!(:purchased_tender_document) { FactoryBot.create(:tender) }

  background do
    login_as(purchased_tender_document.contractor, scope: :contractor)
  end

  scenario 'A contractor can view  the general information of their purchased tender document' do
    visit tenders_project_information_path(purchased_tender_document)

    contractor_should_see_purchased_tender_document_content
  end

  scenario 'A contractor can view the tender documents of their purchased tender document' do
    skip 'working on it'
  end

  scenario 'A contractor can view the bill of quantities of their purchased tender document' do
    skip 'working on it'
  end

  scenario 'A contractor can upload the required documents for their purchased tender document' do
    skip 'working on it'
  end

  scenario 'A contractor can upload other documents for their purchased tender document' do
    skip 'working on it'
  end

  scenario 'A contractor can fill and submit their purchased tender document' do
    skip 'working on it'
  end

  scenario 'A contractor can see the tendering results of their purchased tender document' do
    skip 'working on it'
  end

  private

  def contractor_should_see_purchased_tender_document_content
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
end
