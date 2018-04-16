# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'QuantitySurveyor authentication', type: :feature do
  let(:new_quantity_surveyor) { FactoryBot.build(:quantity_surveyor) }
  let(:existing_quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }

  scenario 'A new quantity surveyor can sign up successfully' do
    visit new_quantity_surveyor_registration_path

    fill_in 'Your name', with: new_quantity_surveyor.full_name
    fill_in 'Email address', with: new_quantity_surveyor.email
    fill_in 'Phone number', with: new_quantity_surveyor.phone_number
    fill_in 'Company name', with: new_quantity_surveyor.company_name
    attach_file('Company logo', Rails.root + 'spec/fixtures/company_logo.png')
    fill_in 'Password', with: new_quantity_surveyor.password
    fill_in 'Password confirmation', with: new_quantity_surveyor.password

    click_button 'Sign up'

    should_have_dashboard_content_for new_quantity_surveyor
    expect(page).to have_content 'Welcome! You have signed up successfully.'

    click_link 'Account Information'

    expect(page).to have_content 'Account Information'
    expect(page).to have_field 'Full name', with: new_quantity_surveyor.full_name
    expect(page).to have_field 'Email', with: new_quantity_surveyor.email
    expect(page).to have_field 'Phone number', with: new_quantity_surveyor.phone_number
    expect(page).to have_field 'Company name', with: new_quantity_surveyor.company_name

    expect(page).to have_css('#company_logo_image')
  end

  scenario 'An existing quantity surveyor can log in successfully' do
    visit new_quantity_surveyor_session_path

    fill_in 'Email address', with: existing_quantity_surveyor.email
    fill_in 'Password', with: existing_quantity_surveyor.password
    click_button 'Log in'

    should_have_dashboard_content_for existing_quantity_surveyor
  end

  scenario 'A logged in quantity_surveyor can log out successfully' do
    login_as(existing_quantity_surveyor, scope: :quantity_surveyor)

    visit quantity_surveyor_root_path

    click_link 'Logout'

    should_see_quantity_surveyor_sign_in_page
  end

  def should_have_dashboard_content_for(quantity_surveyor)
    expect(page).to have_content 'Home'
    expect(page).to have_content quantity_surveyor.company_name
    expect(page).to have_content 'Account Information'
    expect(page).to have_content 'Logout'
    expect(page).to have_content 'Unsent Request For Tender'
    expect(page).to have_content 'Published Requests For Tender'
    expect(page).to have_content 'Closed Tenders'
  end

  def should_see_quantity_surveyor_sign_in_page
    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Log in as a quantity surveyor'
    expect(page).to have_content 'or sign up'
    expect(page).to have_content 'Log in'
  end
end
