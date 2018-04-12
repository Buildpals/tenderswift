# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Contractor can view their dashboard' do
  let!(:contractor) { FactoryBot.create(:contractor) }

  scenario 'when logged in' do
    login_as(contractor, scope: :contractor)

    visit contractor_root_path

    expect(page).to have_content 'Invitations To Tender'
  end

  scenario 'when not logged in' do
    visit contractor_root_path

    expect(page)
      .to have_content 'You need to sign in or sign up before continuing.'

    expect(page).to have_content 'Log in'
    expect(page).to have_field('Email address')
    expect(page).to have_field('Password')
  end
end
