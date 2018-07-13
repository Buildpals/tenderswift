# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Create request for tender', js: true do
  include RequestForTendersHelper

  let!(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }

  let!(:request_for_tender) do
    FactoryBot.create(:request_for_tender,
                      quantity_surveyor: quantity_surveyor,
                      published_at: nil)
  end

  scenario 'should publish a request for tender' do
    given_a_quantity_surveyor_who_has_logged_in

    when_they_publish_a_request_for_tender(request_for_tender)

    and_the_request_for_tender_should_appear_in_their_pending_review_tenders(request_for_tender)
  end
end

def given_a_quantity_surveyor_who_has_logged_in
  login_as quantity_surveyor, scope: :quantity_surveyor
end

def when_they_publish_a_request_for_tender(request_for_tender)
  visit request_for_tender_build_path(request_for_tender, :distribution)

  fill_in 'Selling price', with: 1

  accept_confirm do
    click_button 'Publish'
  end

  expect(page).to have_content 'Your request for tender has been submitted, ' \
                               'and will be published after being reviewed by' \
                               ' the TenderSwift team'
end

def and_the_request_for_tender_should_have_a_purchase_tender_page(request_for_tender)
  new_window = window_opened_by { click_link :purchase_link }
  within_window new_window do
    should_have_content_of_request_for_tender(request_for_tender)
  end
end

def and_the_request_for_tender_should_appear_in_their_pending_review_tenders(request_for_tender)
  visit quantity_surveyor_root_path

  within :css, '#pending-review-request-for-tenders' do
    expect(page).to have_content request_for_tender.project_name
    expect(page).to have_content project_location request_for_tender
  end
end