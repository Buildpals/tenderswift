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

  let!(:request_for_tender_two) do
    FactoryBot.create(:request_for_tender,
                      :published, :submitted,
                      publisher: publisher)
  end

	xscenario 'should see view count updates' do
		visit query_request_for_tender_path
		fill_in 'reference_number', with: request_for_tender.id
		click_button 'search'
    sign_in_publisher
		click_link request_for_tender.project_name

		within :css, '#number-of-counts' do
			expect(page).to have_content '1'
		end

	end

	xscenario 'should see view purchase counts' do
    sign_in_publisher
		click_link request_for_tender.project_name

		within :css, '#number-of-purchases' do
			expect(page).to have_content request_for_tender.number_of_tender_purchases
		end

	end

	xscenario 'should see number of submitted tenders' do
		sign_in_publisher
		click_link request_for_tender.project_name

		within :css, '#number-of-submitted-tender' do
			expect(page).to have_content request_for_tender.tenders.submitted.count
		end
  end

  xscenario 'should see ends on date' do
    sign_in_publisher
    click_link request_for_tender.project_name

    within :css, '#deadline-request-for-tender' do
      expect(page).to have_content time_to_deadline request_for_tender
    end
  end

  xscenario 'should see reference number' do
    sign_in_publisher
    click_link request_for_tender.project_name

    within :css, '#reference-number' do
      expect(page).to have_content request_for_tender.id
    end
  end

=begin
    this test does not pass
=end
  xscenario 'portal link should work' do
    sign_in_publisher
    click_link request_for_tender.project_name

    click_link 'purchase_link', wait: 10

    expect(page).to have_content request_for_tender.project_name
    expect(page).to have_content time_to_deadline request_for_tender
    expect(page).to have_content "Click here if you've already
                                  purchased this tender"
  end


  xscenario 'should see correct selling price' do
    sign_in_publisher
    click_link request_for_tender.project_name

    click_link 'list-purchases-list'

    within :css, '#selling-price-of-tender' do
      expect(page).to have_content request_for_tender.selling_price
    end
  end


  xscenario 'should see amount receivable' do
    sign_in_publisher
    click_link request_for_tender.project_name

    click_link 'list-purchases-list'

    within :css, '#amount-receivable' do
      expect(page).to have_content request_for_tender.total_receivable
    end
  end

  xscenario 'empty state of purchases' do
    sign_in_publisher
    click_link request_for_tender_two.project_name

    click_link 'list-purchases-list'

    expect(page).to have_content 'No contractor has purchased yet'
  end

  xscenario 'empty state of submissions' do
    sign_in_publisher
    click_link request_for_tender_two.project_name

    click_link 'list-submissions-list'

    expect(page).to have_content 'No contractor has submitted yet'
  end


  scenario 'should update bank information' do
    sign_in_publisher
    click_link request_for_tender_two.project_name

    click_link 'list-cashout-list'
    within :css, '#update-bank-information' do
      select 'Monthly', from: 'Withdrawal frequency'
      fill_in 'Bank name', with: 'Cal Bank'
      fill_in 'Branch name', with: 'Circle'
      fill_in 'Account number', with: '1214242342'
      click_button 'Save'
    end

    expect(page).to have_content 'Your changes have been saved!'
  end




  def sign_in_publisher
    visit new_publisher_session_path
    fill_in 'Email address', with: publisher.email
    fill_in 'Password', with: publisher.password
    click_button 'Log in'
  end
end
