# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Admin authentication', type: :feature do
  let(:existing_admin) { FactoryBot.create(:admin) }
  let!(:request_for_tender_one) { FactoryBot.create(:request_for_tender) }
  let!(:request_for_tender_two) { FactoryBot.create(:request_for_tender) }

  scenario 'should login an existing admin successfully' do
    visit new_admin_session_path

    fill_in 'Email', with: existing_admin.email
    fill_in 'Password', with: existing_admin.password
    click_button 'Log in'

    should_have_dashboard_content_for existing_admin
  end

  scenario 'should logout a logged in admin successfully' do
    login_as(existing_admin, scope: :admin)

    visit rails_admin.dashboard_path

    click_link 'Log out'

    should_see_admin_sign_in_page
  end

  scenario 'should login into a Quantity Surveyor Account' do
    visit new_admin_session_path

    fill_in 'Email', with: existing_admin.email
    fill_in 'Password', with: existing_admin.password
    click_button 'Log in'
    click_link request_for_tender_one.project_name
    expect(page).to have_content 'Reverse Account'
    expect(page).to have_content request_for_tender_one.quantity_surveyor.company_name
  end

  scenario 'should logout of a Quantity Surveyor\'s Account' do
    visit new_admin_session_path

    fill_in 'Email', with: existing_admin.email
    fill_in 'Password', with: existing_admin.password
    click_button 'Log in'
    click_link request_for_tender_one.project_name
    click_link 'Reverse Account'
    should_have_dashboard_content_for existing_admin
  end

  def should_have_dashboard_content_for(admin)
    expect(page).to have_content 'Dashboard'
    expect(page).to have_content admin.email
  end

  def should_see_admin_sign_in_page
    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Log in'
  end
end
