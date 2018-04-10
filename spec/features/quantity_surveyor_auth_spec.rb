# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'QuantitySurveyor Authentication', type: :feature do
  let!(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }

  scenario 'QuantitySurveyor signs up' do
    visit '/quantity_surveyors/sign_up'

    fill_in 'Your name', with: quantity_surveyor.full_name
    fill_in 'Email address', with: quantity_surveyor.email
    fill_in 'Phone number', with: quantity_surveyor.phone_number
    fill_in 'Company name', with: quantity_surveyor.company_name
    fill_in 'Password', with: quantity_surveyor.password
    fill_in 'Password confirmation', with: quantity_surveyor.password
    click_button 'Sign up'

    find('body').has_content?('Welcome! You have signed up successfully.')
  end

  scenario 'QuantitySurveyor sign in' do
    visit '/quantity_surveyors/sign_in'

    fill_in 'Email address', with: quantity_surveyor.email
    fill_in 'Password', with: quantity_surveyor.password
    click_button 'Log in'

    find('body').has_content?('Signed in successfully.')
  end
end
