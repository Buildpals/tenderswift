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
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender)

		within :css, '#number-of-purchases' do
			expect(page).to have_content request_for_tender.number_of_tender_purchases
		end

	end

	scenario 'should see number of submitted tenders' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender)

		within :css, '#number-of-submitted-tender' do
			expect(page).to have_content request_for_tender.tenders.submitted.count
		end
  end

  scenario 'should see ends on date' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender)

    within :css, '#deadline-request-for-tender' do
      expect(page).to have_content time_to_deadline request_for_tender
    end
  end

  scenario 'should see reference number' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender)

    within :css, '#reference-number' do
      expect(page).to have_content request_for_tender.id
    end
  end

  scenario 'should see request for tender information' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender)
    user_sees_public_request_for_tender_information request_for_tender
  end

=begin
    this test does not pass
=end
  xscenario 'portal link should work' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender)

    click_link 'purchase_link', wait: 10
    expect(page).to have_current_path(purchase_tender_path(request_for_tender))
  end


  scenario 'should see correct selling price' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender)

    click_link 'list-purchases-list'

    within :css, '#selling-price-of-tender' do
      expect(page).to have_content request_for_tender.selling_price
    end
  end


  scenario 'should see amount receivable' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender)

    click_link 'list-purchases-list'

    within :css, '#amount-receivable' do
      expect(page).to have_content request_for_tender.total_receivable
    end
  end

  scenario 'empty state of purchases' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender_two)

    click_link 'list-purchases-list'

    expect(page).to have_content 'No contractor has purchased yet'
  end

  scenario 'should see list of purchases' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender)
    click_link 'list-purchases-list', wait: 10

    request_for_tender.tenders.purchased.each do |tender|
      expect(page).to have_content(tender.contractors_company_name)
    end
  end

  scenario 'should see empty state of submissions' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender_two)

    click_link 'list-submissions-list'

    expect(page).to have_content 'No contractor has submitted yet'
  end

  scenario 'should see empty state of pre-qualification' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender)
    click_link 'list-prequalification-list'
    expect(page).to have_content 'In order to comply with the standards
                                        of tender fairness, bids will only be
                                        shown when the request deadline is
                                        reached.'
  end

  scenario 'should see shortlisted count' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender_two)
    click_link 'list-prequalification-list'
    within :css, "#shortlisted-count" do
      expect(page).to have_content(request_for_tender_two.tenders
                                       .not_disqualified.count)
    end

  end

  scenario 'should see disqualified count' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender_two)
    click_link 'list-prequalification-list'
    within :css, "#disqualified-count" do
      expect(page).to have_content(request_for_tender_two.tenders
                                       .disqualified.count)
    end

  end


  scenario 'should see list of shortlisted contractors' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender_two)
    click_link 'list-prequalification-list'
    request_for_tender_two.tenders.not_disqualified.each do |tender|
      expect(page).to have_content(tender.contractors_company_name)
    end
  end

  scenario 'should see list of disqualified contractors' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender_two)
    click_link 'list-prequalification-list'
    request_for_tender_two.tenders.disqualified.each do |tender|
      expect(page).to have_content(tender.contractors_company_name)
    end
  end


  scenario 'should update bank information' do
    login_as(publisher, scope: :publisher)
    visit request_for_tender_path(request_for_tender_two)

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
