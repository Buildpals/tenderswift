# frozen_string_literal: true

require 'rails_helper'

RSpec.xfeature 'Search for request for tender', type: :feature do
  let(:request_for_tender) { FactoryBot.create(:request_for_tender) }

  scenario 'should find and display a request for tender when its reference ' \
           'number is typed into the search field of the find request for ' \
           'tender page', js: true do
    visit query_request_for_tender_path
    fill_in 'reference_number', with: request_for_tender.id
    click_button 'search'

    user_sees_public_request_for_tender_information(request_for_tender)
  end

  scenario 'should find and display a request for tender when its reference ' \
           'number is provided in the url', js: true do
    visit purchase_tender_path(request_for_tender.id)
    user_sees_public_request_for_tender_information(request_for_tender)
  end

  scenario 'should display appropriate error when the wrong reference ' \
           'number is typed into the search field of the find request for ' \
           'tender page', js: true do
    visit query_request_for_tender_path
    fill_in 'reference_number', with: '34353'
    click_button 'search'
    expect(page).to have_content 'Sorry, we couldn\'t find a request ' \
                             'for tender with the specified reference number.'
  end

  scenario 'should redirect to the find a request for tender page when a ' \
             'wrong reference number is provided in the url' do
    visit purchase_tender_path(5454)
    within :css, '#search-wrapper' do
      expect(page).to have_field :reference_number
    end
  end

  context 'Request for tender has not been published yet' do
    let!(:unpublished_request_for_tender) do
      FactoryBot.create(:request_for_tender, published_at: nil)
    end

    scenario 'should prevent contractor from purchasing the request for tender',
             js: true do
      visit query_request_for_tender_path
      fill_in 'reference_number', with: unpublished_request_for_tender.id
      click_button 'search'
      expect(page)
        .to have_content 'Account The tender has not been made ' \
                                 'available for purchasing'
    end
  end
end
