# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Publisher authentication', type: :feature, js: true do
  let(:new_publisher) { FactoryBot.build(:publisher) }
  let(:existing_publisher) { FactoryBot.create(:publisher) }

  scenario 'should sign up a new publisher successfully', js: true do
    visit new_publisher_registration_path

    fill_in 'Your name', with: new_publisher.full_name
    fill_in 'Email address', with: new_publisher.email
    fill_in 'Phone number', with: new_publisher.phone_number
    fill_in 'Company name', with: new_publisher.company_name
    attach_file('Company logo', Rails.root + 'spec/fixtures/company_logo.png')
    fill_in 'Password', with: new_publisher.password
    fill_in 'Password confirmation', with: new_publisher.password

    click_button 'Sign up'

    should_have_dashboard_content_for new_publisher
    expect(page)
        .to have_content 'Welcome! You have signed up successfully.'

    click_link 'Account'

=begin
    find_link 'Edit your account information'.click

    #expect(page).to have_content 'Account Information'

    expect(page).to have_field 'Your name',
                               with: new_publisher.full_name

    expect(page).to have_field 'Email address',
                               with: new_publisher.email

    expect(page).to have_field 'Phone number',
                               with:  new_publisher.phone_number

    expect(page).to have_field 'Company name',
                               with: new_publisher.company_name

    expect(page).to have_css('#company_logo_image')
=end
  end

  scenario 'should log in an existing publisher successfully' do
    visit new_publisher_session_path

    fill_in 'Email address', with: existing_publisher.email
    fill_in 'Password', with: existing_publisher.password
    click_button 'Log in'

    should_have_dashboard_content_for existing_publisher
  end

  scenario 'should log out a logged in publisher successfully' do
    login_as(existing_publisher, scope: :publisher)

    visit publisher_root_path

    click_link 'Account'
    click_link 'Logout'

    should_see_publisher_sign_in_page
  end

  def should_have_dashboard_content_for(publisher)
    expect(page).to have_content 'Home'
    #expect(page).to have_content publisher.company_name
    click_link 'Account'
    #expect(page).to have_content 'Account Information'
    expect(page).to have_content 'Logout'
    expect(page).to have_content 'Unpublished requests for tender'
    expect(page).to have_content 'Published requests for tender'
    expect(page).to have_content 'Closed requests for tender'
  end

  def should_see_publisher_sign_in_page
    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Log in as a publisher'
    expect(page).to have_content 'Log in'
  end
end
