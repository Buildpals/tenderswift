# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'View results of a request for tender', js: true do

  include RequestForTendersHelper
  let!(:publisher) {FactoryBot.create(:publisher, :finished_registration)}
  let!(:invitation_to_tender) do
    FactoryBot.create(:request_for_tender,
                      :published, :submitted,
                      deadline: Time.now,
                      publisher: publisher)
  end

  let(:contractor) { FactoryBot.create(:contractor) }


  let(:submitted_tender_document) do
    FactoryBot.create(:submitted_tender,
                      request_for_tender: invitation_to_tender,
                      contractor: contractor)
  end

  scenario 'should allow publisher to cash out' do
    login_as(publisher, scope: :publisher)
    visit publisher_root_path
    within :css, '#closed-request-for-tenders' do
      click_link invitation_to_tender.project_name
    end
    click_link 'Cashout'
    expect(page).to have_content 'Amount receivable'
    expect(page).to have_content invitation_to_tender.total_receivable
  end
end