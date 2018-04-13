# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Contractor Authentication', type: :feature do
  # Factorybot.build because we DON'T want the contractor to
  # be created in the database
  let!(:contractor) { FactoryBot.build(:contractor) }

  # Factorybot.create because we DO want the contractor to
  # be created in the database
  let!(:existing_contractor) { FactoryBot.create(:contractor) }

  scenario 'Contractor signs up' do
    visit new_contractor_registration_path

    fill_in 'Your name', with: contractor.full_name
    fill_in 'Email address', with: contractor.email
    fill_in 'Phone number', with: contractor.phone_number
    fill_in 'Company name', with: contractor.company_name
    fill_in 'Password', with: contractor.password
    fill_in 'Password confirmation', with: contractor.password

    click_button 'Sign up'

    should_have_dashboard_content_for contractor
    expect(page).to have_content 'Welcome! You have signed up successfully.'

    # click_link 'Account Information'

    # expect(page).to have_content 'Account Information'
    # expect(page).to have_field 'Full name', with: contractor.full_name
    # expect(page).to have_field 'Email', with: contractor.email
    # expect(page).to have_field 'Phone number', with: contractor.phone_number
    # expect(page).to have_field 'Company name', with: contractor.company_name

    # TODO: Check if the company logo is present
  end

  scenario 'Contractor logs in' do
    visit new_contractor_session_path

    fill_in 'Email address', with: existing_contractor.email
    fill_in 'Password', with: existing_contractor.password
    click_button 'Log in'

    should_have_dashboard_content_for existing_contractor
  end
end

def should_have_dashboard_content_for(contractor)
  expect(page).to have_content 'Home'
  expect(page).to have_content contractor.company_name
end

