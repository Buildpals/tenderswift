# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Search for request for tender', type: :feature do

  let(:request_for_tender) { FactoryBot.create(:request_for_tender) }

  scenario 'should allow a visitor to find a tender' do
    visit query_request_for_tender_path
    fill_in 'reference_number', with: request_for_tender.id
    click_button 'search'
    expect(page).to have_content 'Project Information'
  end

  scenario 'should not allow a visitor to find a tender' do
    visit query_request_for_tender_path
    fill_in 'reference_number', with: '34353'
    click_button 'search'
    expect(page).to have_content 'No request for tender was not found'
  end

end