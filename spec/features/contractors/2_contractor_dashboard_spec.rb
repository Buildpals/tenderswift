# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Contractor dashboard' do
  let(:contractor) { FactoryBot.create(:contractor) }

  let!(:rft_with_purchased_tender) do
    FactoryBot.create(:request_for_tender)
  end

  let!(:rft_with_un_purchased_tender) do
    FactoryBot.create(:request_for_tender)
  end

  let!(:rft_with_no_tender) do
    FactoryBot.create(:request_for_tender)
  end

  let!(:rft_with_submitted_tender) do
    FactoryBot.create(:request_for_tender)
  end

  let!(:purchased_tender) do
    FactoryBot.create(:tender,
                      :purchased,
                      request_for_tender: rft_with_purchased_tender,
                      contractor: contractor)
  end

  let!(:tender_with_attempted_purchase) do
    FactoryBot.create(:tender,
                      purchased_at: nil,
                      request_for_tender: rft_with_un_purchased_tender,
                      contractor: contractor)
  end

  let!(:submitted_tender) do
    FactoryBot.create(:tender,
                      :purchased,
                      :submitted,
                      request_for_tender: rft_with_submitted_tender,
                      contractor: contractor)
  end

  context 'when logged in' do
    background do
      login_as(contractor, scope: :contractor)
    end

    scenario 'should show the contractor their purchased tender documents' do
      visit contractor_root_path
      within :css, '#purchased-tenders' do
        expect(page).to have_content purchased_tender.project_name

        expect(page).not_to have_content tender_with_attempted_purchase
          .project_name
        expect(page).not_to have_content submitted_tender.project_name
      end
    end

    scenario 'should show the contractor their submitted tender documents' do
      visit contractor_root_path
      within :css, '#submitted-tenders' do
        expect(page).to have_content submitted_tender.project_name

        expect(page).not_to have_content purchased_tender.project_name
        expect(page).not_to have_content tender_with_attempted_purchase.project_name
      end
    end
  end

  context 'when logged out' do
    scenario 'should redirect the contractor to the login page' do
      visit contractor_root_path

      expect(page).to have_content 'You need to sign in or sign up ' \
                                         'before continuing.'
      expect(page).to have_content 'Log in'
      expect(page).to have_field('Email address')
      expect(page).to have_field('Password')
    end
  end
end
