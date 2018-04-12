# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Contractor Authentication', type: :feature do
  let!(:contractor) { FactoryBot.create(:contractor) }

  scenario 'Contractor signs up' do
    visit '/contractors/sign_up'

    fill_in 'Your name', with: contractor.full_name
    fill_in 'Email address', with: contractor.email
    fill_in 'Phone number', with: contractor.phone_number
    fill_in 'Company name', with: contractor.company_name
    fill_in 'Password', with: contractor.password
    fill_in 'Password confirmation', with: contractor.password
    click_button 'Sign up'

    find('body').has_content?('Welcome! You have signed up successfully.')
  end

  scenario 'Contractor logs in' do
    visit '/contractors/sign_in'

    fill_in 'Email address', with: contractor.email
    fill_in 'Password', with: contractor.password
    click_button 'Log in'

    find('body').has_content?('Signed in successfully.')
  end
end
