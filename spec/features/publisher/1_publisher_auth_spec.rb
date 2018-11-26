# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Publisher authentication', type: :feature, js: true do
  let(:new_publisher) { FactoryBot.build(:publisher) }
  let(:existing_publisher) { FactoryBot.create(:publisher, :finished_registration) }

  scenario 'should sign up a new publisher successfully', js: true do
    visit new_publisher_registration_path

    fill_in 'Full name', with: new_publisher.full_name
    fill_in 'Email address', with: new_publisher.email

    click_button 'Sign up'

    expect(page)
        .to have_content 'Welcome Please fill in the following ' \
                                'information so you can be given access to your account'

    fill_in 'Company name', with: 'My company'

    fill_in 'Phone number', with: '0509825831'

    click_button 'Finish', match: :first

    expect(page)
        .to have_content 'Ready to go! ' \
                                'A message with a confirmation link ' \
                                'has been sent to your email address. Please open the ' \
                                'link to set a password for your account.'

    expect(page).to have_content 'Home'
    click_link 'Account'
    expect(page).to have_content "Logged in as #{new_publisher.full_name}"
    expect(page).to have_content 'Logout'
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
    click_link 'Account'
    expect(page).to have_content "Logged in as #{publisher.full_name}"
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
