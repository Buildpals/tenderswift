# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Search for request for tender', type: :feature do
  let(:request_for_tender) { FactoryBot.create(:request_for_tender) }

  scenario 'should find and display a request for tender when its reference ' \
           'number is typed into the search field of the find request for ' \
           'tender page', js: true do
    visit query_request_for_tender_path
    fill_in 'reference_number', with: request_for_tender.id
    click_button 'search'
    expect(page).to have_content request_for_tender.project_name
    expect(page).to have_content request_for_tender.project_owners_company_name
    expect(page).to have_content request_for_tender.deadline.to_formatted_s(:long)

    expect(page).to have_content request_for_tender.description

    request_for_tender.required_documents.each do |required_document|
      expect(page).to have_content required_document.title
    end

    expect(page).to have_content request_for_tender.tender_instructions
  end

  scenario 'should find and display a request for tender when its reference ' \
           'number is provided in the url', js: true do
    visit purchase_tender_path(request_for_tender.id)
    expect(page).to have_content request_for_tender.project_name
    expect(page).to have_content request_for_tender.project_owners_company_name
    expect(page).to have_content request_for_tender.deadline.to_formatted_s(:long)

    expect(page).to have_content request_for_tender.description

    request_for_tender.required_documents.each do |required_document|
      expect(page).to have_content required_document.title
    end

    expect(page).to have_content request_for_tender.tender_instructions
  end

  context 'when visitor tries to find a tender' do




    scenario 'should display appropriate error when the wrong reference ' \
           'number is typed into the search field of the find request for ' \
           'tender page', js: true do
      visit query_request_for_tender_path
      fill_in 'reference_number', with: '34353'
      click_button 'search'
      expect(page).to have_content 'Sorry, we couldn\'t find a request ' \
                             'for tender with the specified reference number.'
    end

    scenario 'should redirect to the find a request for tender page when a ' \
             'wrong reference number is provided in the url' do
      visit purchase_tender_path(5454)
      within :css, '#search-wrapper' do
        expect(page).to have_field :reference_number
      end
    end
  end
end
