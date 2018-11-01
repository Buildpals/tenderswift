# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Create request for tender', js: true do
  include RequestForTendersHelper

  let!(:publisher) {FactoryBot.create(:publisher)}

  let!(:request_for_tender) do
    FactoryBot.create(:request_for_tender,
                      publisher: publisher,
                      published_at: nil)
  end

  scenario 'should publish a request for tender' do
    given_a_publisher_who_has_logged_in

    when_they_publish_a_request_for_tender(request_for_tender)

    then_the_rft_should_appear_in_published_tenders_as_publishing(
        request_for_tender
    )
  end

  scenario 'should show the request for tender fee' do
    invitation_to_tender = FactoryBot.create(:request_for_tender)
    visit purchase_tender_path invitation_to_tender
    expect(page).to have_content(
                        "Purchase this tender for #{invitation_to_tender.tender_currency}" \
            " #{invitation_to_tender.amount_to_be_deducted}"
                    )
  end

  xscenario 'should not send admin an email when an already published request' \
           'for tender is published again' do
    given_a_publisher_who_has_logged_in
    when_they_publish_a_request_for_tender(request_for_tender)
    visit request_for_tender_build_path(request_for_tender, :distribution)
    expect {click_button 'Publish'}
        .to change {ActionMailer::Base.deliveries.count}.by(0)
  end

  scenario 'should move to tender instructions page when ' \
           'previous button is pressed' do
    given_a_publisher_who_has_logged_in

    visit request_for_tender_build_path(request_for_tender, :distribution)
    click_link 'Previous'
    expect(page).to have_current_path(
                        request_for_tender_build_path(request_for_tender, :tender_instructions)
                    )
  end
end

def given_a_publisher_who_has_logged_in
  login_as publisher, scope: :publisher
end

def when_they_publish_a_request_for_tender(request_for_tender)
  visit request_for_tender_build_path(request_for_tender, :distribution)

  # TODO: Check preview link

  select 'Closed - Only people with the link can tender',
         from: 'request_for_tender_access'

  fill_in 'request_for_tender_participants_attributes_0_email',
          with: Faker::Internet.safe_email

  fill_in 'request_for_tender_participants_attributes_1_email',
          with: Faker::Internet.safe_email

  fill_in 'request_for_tender_participants_attributes_2_email',
          with: Faker::Internet.safe_email

  # TODO: Check adding another participant
  # click_link 'Add another participant'
  #
  # fill_in placeholder: 'Email', match: :one,
  #         with: Faker::Internet.safe_email


  select 'KES - Kenyan Shillings',
         from: :request_for_tender_tender_currency

  fill_in 'Tender fee', with: 1

  accept_confirm do
    click_button 'Publish'
  end

  expect(page).to have_content(
                      'Your request for tender has been published. Share this link ' \
    "https://public.tenderswift.com/#{request_for_tender.id} " \
    'with anyone you wish to submit a bid for this request'
                  )
end

def and_the_request_for_tender_should_have_a_purchase_tender_page(
    request_for_tender
)
  new_window = window_opened_by {click_link :purchase_link}
  within_window new_window do
    should_have_content_of_request_for_tender(request_for_tender)
  end
end

def then_the_rft_should_appear_in_published_tenders_as_publishing(
    request_for_tender
)
  visit publisher_root_path
  within :css, '#published-request-for-tender' do
    within page.find('a', text: request_for_tender.project_name) do
      expect(page).to have_content request_for_tender.project_name
      # expect(page).to have_content status request_for_tender
      expect(page).to have_content project_location request_for_tender
    end
  end
end
