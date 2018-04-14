# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Contractor authentication', type: :feature do
  let!(:new_contractor) { FactoryBot.build(:contractor) }
  let!(:existing_contractor) { FactoryBot.create(:contractor) }

  scenario 'A new contractor can sign up successfully' do
    visit new_contractor_registration_path

    fill_in 'Your name', with: new_contractor.full_name
    fill_in 'Email address', with: new_contractor.email
    fill_in 'Phone number', with: new_contractor.phone_number
    fill_in 'Company name', with: new_contractor.company_name
    fill_in 'Password', with: new_contractor.password
    fill_in 'Password confirmation', with: new_contractor.password

    click_button 'Sign up'

    should_have_dashboard_content_for new_contractor
    expect(page).to have_content 'Welcome! You have signed up successfully.'

    # click_link 'Account Information'

    # expect(page).to have_content 'Account Information'
    # expect(page).to have_field 'Full name', with: new_contractor.full_name
    # expect(page).to have_field 'Email', with: new_contractor.email
    # expect(page).to have_field 'Phone number', with: new_contractor.phone_number
    # expect(page).to have_field 'Company name', with: new_contractor.company_name

    # TODO: Check if the company logo is present
  end

  scenario 'An existing contractor can log in successfully' do
    visit new_contractor_session_path

    fill_in 'Email address', with: existing_contractor.email
    fill_in 'Password', with: existing_contractor.password
    click_button 'Log in'

    should_have_dashboard_content_for existing_contractor
  end

  def should_have_dashboard_content_for(contractor)
    expect(page).to have_content 'Home'
    expect(page).to have_content contractor.company_name
  end
end