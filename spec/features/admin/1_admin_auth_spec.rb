# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Admin authentication', type: :feature do
  let!(:existing_admin) { FactoryBot.create(:admin) }

  scenario 'An existing admin can log in successfully' do
    visit new_admin_session_path

    fill_in 'Email', with: existing_admin.email
    fill_in 'Password', with: existing_admin.password
    click_button 'Log in'

    should_have_dashboard_content_for existing_admin
  end

  scenario 'An existing admin can log out successfully' do
    login_as(existing_admin, scope: :admin)

    visit '/adonai'

    click_link 'Log out'

    should_see_admin_sign_in_page
  end


  def should_have_dashboard_content_for(admin)
    expect(page).to have_content 'Ds02 Server Admin'
    expect(page).to have_content 'Dashboard'
    expect(page).to have_content 'Home'
    expect(page).to have_content admin.email
    expect(page).to have_content 'Log out'
    expect(page).to have_content 'Site Administration'
  end

  def should_see_admin_sign_in_page
    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Log in'
    expect(page).to have_content 'Email'
    expect(page).to have_content 'Password'
  end
end
