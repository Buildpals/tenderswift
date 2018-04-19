# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Contractor dashboard' do
  let(:tender) { FactoryBot.create(:tender) }
  let!(:purchased_tender) do
    FactoryBot.create(:purchased_tender, contractor: tender.contractor)
  end

  context 'when logged in' do
    background do
      login_as(tender.contractor, scope: :contractor)
    end

    scenario 'should show the contractor their private invitations to tender' do
      visit contractor_root_path
      within :css, '#invitations-to-tender' do
        expect(page).to have_content tender.project_name
      end
    end

    scenario 'should show the contractor their purchased tender documents' do
      visit contractor_root_path
      within :css, '#purchased-tenders' do
        expect(page).to have_content purchased_tender.project_name
      end
    end

    scenario 'should show the contractor their submitted tender documents' do
      skip 'Spec not finished'
    end
  end

  context 'when logged out' do
    scenario 'should redirect the contractor to the login page' do
      visit contractor_root_path

      expect(page)
        .to have_content 'You need to sign in or sign up before continuing.'
      expect(page).to have_content 'Log in'
      expect(page).to have_field('Email address')
      expect(page).to have_field('Password')
    end
  end
end
