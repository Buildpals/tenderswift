# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Creating Request For Tender' do
  let!(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }
  let!(:request_for_tender) { FactoryBot.build(:request_for_tender) }

  before do
    login_as(quantity_surveyor)
  end

  scenario 'with valid attributes' do
    visit '/'

    click_link 'Create Request For Tender'
    expect(page).to have_content 'Untitled Project #'
    expect(page).to have_content 'General Information'

    fill_in 'Project name', with: request_for_tender.project_name
    select 'GHS - Ghanaian Cedi', from: 'Currency'

    select '10', from: 'request_for_tender_deadline_3i'
    select 'May', from: 'request_for_tender_deadline_2i'
    select '2018', from: 'request_for_tender_deadline_1i'
    select '3 PM', from: 'request_for_tender_deadline_4i'
    select '00', from: 'request_for_tender_deadline_5i'

    select 'Ghana', from: 'Country'
    fill_in 'City', with: request_for_tender.city

    fill_in 'Description', with: request_for_tender.city
    go_to_next_page
    expect(page).to have_content 'Bill Of Quantities'

    # skip 'Upload Bill of Quantities'
    # skip 'Check that tender figure for Bill of Quantities is correct'
    go_to_next_page
    expect(page).to have_content 'Tender Documents'

    # skip 'Upload tender documents'
    go_to_next_page
    expect(page).to have_content 'Tender Instructions'

    # skip 'Fill in tender instructions'
    go_to_next_page
    expect(page).to have_content 'Payment Method'

    fill_in 'Selling price', with: request_for_tender.selling_price
    fill_in 'Bank name', with: request_for_tender.bank_name
    fill_in 'Branch name', with: request_for_tender.branch_name
    fill_in 'Account name', with: request_for_tender.account_name
    fill_in 'Account number', with: request_for_tender.account_number
    select 'Every two weeks', from: 'Withdrawal frequency'
    go_to_next_page
    expect(page).to have_content 'Distribution'

    within '.top-navigation' do
      click_button 'Publish'
    end

    expect(page).to have_content request_for_tender.project_name
    expect(page).to have_content request_for_tender.contract_class
    expect(page).to have_content request_for_tender.project_location
    expect(page).to have_content request_for_tender.project_currency

    # Time to deadline
    # expect(page).to have_content Time.current + 1.month

    # Deadline
    expect(page).to have_content 'May 10, 2018 15:00'

    expect(page).to have_content request_for_tender.project_description

    request_for_tender.required_documents.each do |required_document|
      expect(page).to have_content required_document.title
    end

    # expect(page).to have_content request_for_tender.tender_instructions
  end

  private

  def go_to_next_page
    within '.top-navigation' do
      click_button 'Next'
    end
  end
end
