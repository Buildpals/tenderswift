# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Admin authentication', type: :feature, js: true do
  let(:existing_admin) { FactoryBot.create(:admin) }
  let!(:request_for_tender_one) { FactoryBot.create(:request_for_tender) }
  let!(:request_for_tender_two) { FactoryBot.create(:request_for_tender) }

  scenario 'should login an existing admin successfully' do
    visit new_admin_session_path

    fill_in 'Email', with: existing_admin.email
    fill_in 'Password', with: existing_admin.password
    click_button 'Log in'
    click_link 'Account'
    should_have_dashboard_content_for existing_admin
  end

  fscenario 'should logout a logged in admin from contractor dashboard ' \
           'successfully' do
    login_as(existing_admin, scope: :admin)

    visit admin_root_path

    click_link "Account"
    click_link 'Logout'

    should_see_admin_sign_in_page
  end

  scenario 'should logout a logged in admin from rails_admin successfully' do
    login_as(existing_admin, scope: :admin)

    visit rails_admin.dashboard_path

    click_link 'Log out'

    should_see_admin_sign_in_page
  end

  def should_have_dashboard_content_for(admin)
    expect(page).to have_current_path admin_root_path

    expect(page).to have_content 'Admin Dashboard'
    expect(page).to have_content admin.email
    expect(page).to have_link 'Rails Admin', href: rails_admin.dashboard_path
  end

  def should_see_admin_sign_in_page
    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Log in'
  end
end
