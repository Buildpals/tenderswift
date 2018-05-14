# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Search for request for tender', type: :feature do

  let(:request_for_tender) { FactoryBot.create(:request_for_tender) }

  context 'when visitor tries to find a tender' do
    scenario 'visitor types reference number in search bar' do
        visit query_request_for_tender_path
        fill_in 'reference_number', with: request_for_tender.id
        click_button 'search'
        expect(page).to have_content 'Project Information'
        expect(page).to have_content request_for_tender.project_name
        expect(page).to have_content request_for_tender.project_owners_company_name
        expect(page).to have_content request_for_tender.deadline.to_formatted_s(:long)

        expect(page).to have_content request_for_tender.description

        request_for_tender.required_documents.each do |required_document|
          expect(page).to have_content required_document.title
        end

        expect(page).to have_content request_for_tender.tender_instructions
    end
    
    scenario 'visitor types reference number in url' do
      visit purchase_tender_path(request_for_tender.id)
      expect(page).to have_content 'Project Information'
      expect(page).to have_content request_for_tender.project_name
      expect(page).to have_content request_for_tender.project_owners_company_name
      expect(page).to have_content request_for_tender.deadline.to_formatted_s(:long)

      expect(page).to have_content request_for_tender.description

      request_for_tender.required_documents.each do |required_document|
        expect(page).to have_content required_document.title
      end

      expect(page).to have_content request_for_tender.tender_instructions
    end

    scenario 'a visitor provides wrong reference number in search bar' do
      visit query_request_for_tender_path
      fill_in 'reference_number', with: '34353'
      click_button 'search'
      expect(page).to have_content 'No request for tender was found'
    end

    scenario 'a visitor provides wrong reference number in url' do
      visit purchase_tender_path(5454)
      expect(page).to have_content 'Find a request for tender'
    end
  end





end