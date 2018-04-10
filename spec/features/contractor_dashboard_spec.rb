# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Contractor can view their dashboard' do
  let!(:contractor) { FactoryBot.create(:contractor) }

  scenario 'when logged in' do
    visit '/contractors/sign_in'

    fill_in 'Email address', with: contractor.email
    fill_in 'Password', with: contractor.password
    click_button 'Log in'

    find('body').has_content?('Signed in successfully.')

    visit contractors_dashboard_path

    expect(page).to have_content 'Invitations To Tender'
  end

  scenario 'when not logged in' do
    visit contractors_dashboard_path

    expect(page).to have_content
    'You need to sign in or sign up before continuing.'

    expect(page).to have_content 'Log in'
    expect(page).to have_field('Email address')
    expect(page).to have_field('Password')
  end
end
