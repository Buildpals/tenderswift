# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'View details of published request for tender', js: true do
  include RequestForTendersHelper
	let!(:publisher) {FactoryBot.create(:publisher)}
  let!(:request_for_tender) do
		FactoryBot.create(:request_for_tender,
											:published, :submitted,
											publisher: publisher)
	end
	let!(:contractor) { FactoryBot.create(:contractor) }
	let!(:tender) { FactoryBot.create(:tender ,:purchased, 
																		request_for_tender: request_for_tender,
																		contractor: contractor ) }

	scenario 'should see view count updates' do
		visit query_request_for_tender_path
		fill_in 'reference_number', with: request_for_tender.id
		click_button 'search'
    sign_in_publisher
		click_link request_for_tender.project_name

		within :css, '#number-of-counts' do
			expect(page).to have_content '1'
		end

	end

	scenario 'should see view purchase counts' do
    sign_in_publisher
		click_link request_for_tender.project_name

		within :css, '#number-of-purchases' do
			expect(page).to have_content request_for_tender.number_of_tender_purchases
		end

	end

	scenario 'should see number of submitted tenders' do
		sign_in_publisher
		click_link request_for_tender.project_name

		within :css, '#number-of-submitted-tender' do
			expect(page).to have_content request_for_tender.tenders.submitted.count
		end
  end

  scenario 'should see ends on date' do
    sign_in_publisher
    click_link request_for_tender.project_name

    within :css, '#deadline-request-for-tender' do
      expect(page).to have_content time_to_deadline request_for_tender
    end
  end

  def sign_in_publisher
    visit new_publisher_session_path
    fill_in 'Email address', with: publisher.email
    fill_in 'Password', with: publisher.password
    click_button 'Log in'
  end
end
