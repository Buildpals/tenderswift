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


  scenario 'should allow publisher to see overview' do
    login_and_click_closed_request_for_tender publisher, invitation_to_tender

    click_link 'Overview'
    expect(page).to have_content invitation_to_tender.project_name
    expect(page).to have_content invitation_to_tender.id
    expect(page).to have_content invitation_to_tender.city
    expect(page).to have_content invitation_to_tender.description
    expect(page).to have_content time_to_deadline invitation_to_tender
    expect(page).to have_content invitation_to_tender.access.humanize
  end

  scenario 'should allow publisher to see purchases' do
    login_and_click_closed_request_for_tender publisher, invitation_to_tender

    click_link 'Purchases'
    expect(page).to have_content invitation_to_tender.number_of_tender_purchases
    expect(page).to have_content invitation_to_tender.total_receivable
    invitation_to_tender.tenders.purchased.each do |tender|
      expect(page).to have_content tender.contractors_company_name
      expect(page).to have_content tender.contractors_email
      expect(page).to have_content tender.contractors_phone_number
    end
  end

  scenario 'should allow publisher to see submissions' do
    login_and_click_closed_request_for_tender publisher, invitation_to_tender

    click_link 'Submissions'
    expect(page).to have_content invitation_to_tender.tenders.submitted.count
  end


  scenario 'should allow publisher to cash out' do
    login_and_click_closed_request_for_tender publisher, invitation_to_tender

    click_link 'Cashout'
    expect(page).to have_content 'Amount receivable'
    expect(page).to have_content invitation_to_tender.total_receivable
  end

  scenario 'should allow publisher to edit request for tender' do
    login_and_click_closed_request_for_tender publisher, invitation_to_tender

    click_link 'Edit Request For Tender'

    expect(page).to have_current_path(
                        request_for_tender_build_path(invitation_to_tender,
                                                      :general_information)
                    )
  end


  def login_and_click_closed_request_for_tender(publisher, request_for_tender)
    login_as(publisher, scope: :publisher)
    visit publisher_root_path
    within :css, '#closed-request-for-tenders' do
      click_link request_for_tender.project_name
    end

  end
end