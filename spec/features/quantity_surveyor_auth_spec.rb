# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'QuantitySurveyor Authentication', type: :feature do
  # Factorybot.build because we DON'T want the quantity_surveyor to
  # be created in the database
  let!(:quantity_surveyor) { FactoryBot.build(:quantity_surveyor) }

  # Factorybot.create because we DO want the quantity_surveyor to
  # be created in the database
  let!(:existing_quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }

  scenario 'QuantitySurveyor signs up' do
    visit new_quantity_surveyor_registration_path

    fill_in 'Your name', with: quantity_surveyor.full_name
    fill_in 'Email address', with: quantity_surveyor.email
    fill_in 'Phone number', with: quantity_surveyor.phone_number
    fill_in 'Company name', with: quantity_surveyor.company_name
    fill_in 'Password', with: quantity_surveyor.password
    fill_in 'Password confirmation', with: quantity_surveyor.password

    click_button 'Sign up'

    should_have_dashboard_content_for quantity_surveyor
    expect(page).to have_content 'Welcome! You have signed up successfully.'

    click_link 'Account Information'

    expect(page).to have_content 'Account Information'
    expect(page).to have_field 'Full name', with: quantity_surveyor.full_name
    expect(page).to have_field 'Email', with: quantity_surveyor.email
    expect(page).to have_field 'Phone number', with: quantity_surveyor.phone_number
    expect(page).to have_field 'Company name', with: quantity_surveyor.company_name

    # TODO: Check if the company logo is present
  end

  scenario 'QuantitySurveyor logs in' do
    visit new_quantity_surveyor_session_path

    fill_in 'Email address', with: existing_quantity_surveyor.email
    fill_in 'Password', with: existing_quantity_surveyor.password
    click_button 'Log in'

    should_have_dashboard_content_for existing_quantity_surveyor
    expect(page).to have_content 'Signed in successfully.'
  end
end

def should_have_dashboard_content_for(quantity_surveyor)
  expect(page).to have_content 'Home'
  expect(page).to have_content quantity_surveyor.company_name
end


