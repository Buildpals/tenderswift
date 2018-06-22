# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Contractor authentication', type: :feature, js: true do
  let(:new_contractor) { FactoryBot.build(:contractor) }
  let(:existing_contractor) { FactoryBot.create(:contractor) }

  scenario 'should sign up a new contractor successfully' do
    visit new_contractor_registration_path

    fill_in 'Email address', with: new_contractor.email
    fill_in 'Phone number', with: new_contractor.phone_number

    click_button 'Sign up'

    expect(page)
      .to have_content 'Welcome! You have signed up successfully.'

    fill_in :contractors_full_name, with: new_contractor.full_name
    fill_in :contractors_company_name, with: new_contractor.company_name
    attach_file(:contractors_company_logo, Rails.root + 'spec/fixtures/company_logo.png')
    fill_in :contractors_password, with: new_contractor.password
    fill_in :contractors_password_confirmation, with: new_contractor.password

    click_button 'Continue'

    should_have_dashboard_content_for new_contractor

    click_link 'Edit your account information'

    expect(page).to have_content 'Account Information'

    expect(page).to have_field 'Full name',
                               with: new_contractor.full_name

    expect(page).to have_field 'Email',
                               with: new_contractor.email

    expect(page).to have_field 'Phone number',
                               with: new_contractor.phone_number

    expect(page).to have_field 'Company name',
                               with: new_contractor.company_name

    expect(page).to have_css('#company_logo_image')
  end

  scenario 'should log in an existing contractor successfully' do
    visit new_contractor_session_path

    fill_in 'Email address', with: existing_contractor.email
    fill_in 'Password', with: existing_contractor.password
    click_button 'Log in'

    should_have_dashboard_content_for existing_contractor
  end

  scenario 'should log out a logged in contractor successfully' do
    login_as(existing_contractor, scope: :contractor)

    visit contractor_root_path

    click_link 'Account'
    click_link 'Logout'

    should_see_contractor_sign_in_page
  end

  def should_have_dashboard_content_for(contractor)
    expect(page).to have_content 'Home'
    click_link 'Account'
    expect(page).to have_content "Logged in as #{contractor.company_name}"
    expect(page).to have_content 'Edit your account information'
    expect(page).to have_content 'Logout'
    expect(page).to have_content 'Invitations To Tender'
    expect(page).to have_content 'Purchased Tenders'
    expect(page).to have_content 'Submitted Tenders'
  end

  def should_see_contractor_sign_in_page
    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Log in as a contractor'
    expect(page).to have_content 'or sign up'
    expect(page).to have_content 'Log in'
  end
end
