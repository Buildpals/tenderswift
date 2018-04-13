# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Contractor can purchase invitation_to_tender' do
  let!(:invitation_to_tender) { FactoryBot.create(:request_for_tender) }
  let!(:contractor) { FactoryBot.build(:contractor) }
  let!(:signed_up_contractor) { FactoryBot.create(:contractor) }

  scenario 'as a new user' do
    visit purchase_tender_path(invitation_to_tender)

    fill_in :signup_company_name, with: contractor.company_name
    fill_in :signup_phone_number, with: contractor.phone_number
    fill_in :signup_email, with: contractor.email
    fill_in :signup_password, with: contractor.password

    select 'MTN Mobile Money', from: :signup_network_code
    fill_in :signup_customer_number, with: contractor.phone_number
    fill_in :signup_vodafone_voucher_code, with: '123456'

    click_button 'Sign up and Purchase'

    should_find_request_for_tender_in_purchased_tenders

    click_link invitation_to_tender.project_name

    should_have_invitation_to_tender_content

    # Check if they show up on the QS dashboard with the right price
    # Check if they can log out and login with the same credentials
  end

  scenario 'when they already have an account' do
    visit purchase_tender_path(invitation_to_tender)

    fill_in :login_email, with: signed_up_contractor.email
    fill_in :login_password, with: signed_up_contractor.password

    select 'MTN Mobile Money', from: :login_network_code
    fill_in :login_customer_number, with: signed_up_contractor.phone_number
    fill_in :login_vodafone_voucher_code, with: '123456'

    click_button 'Log in and Purchase'

    should_find_request_for_tender_in_purchased_tenders

    click_link invitation_to_tender.project_name

    should_have_invitation_to_tender_content
    # Check if they show up on the QS dashboard with the right price
  end

  scenario 'when they are already signed in' do
    # login_as(contractor, scope: :contractor)
    #
    # visit purchase_tender_path(invitation_to_tender)
    #
    # select 'MTN Mobile Money', from: :logged_in_network_code
    # fill_in :logged_in_customer_number, with: signed_up_contractor.phone_number
    # fill_in :logged_in_vodafone_voucher_code, with: '123456'
    #
    # click_button 'Purchase'
    #
    # should_find_request_for_tender_in_purchased_tenders
    #
    # click_link invitation_to_tender.project_name
    #
    # should_have_invitation_to_tender_content
    # # Check if they show up on the QS dashboard with the right price
  end

  private

  def should_find_request_for_tender_in_purchased_tenders
    purchased_tenders_container = page.find('#purchased-tenders')
    expect(purchased_tenders_container).to have_content invitation_to_tender.project_name
  end

  def should_have_invitation_to_tender_content
    expect(page).to have_content invitation_to_tender.project_name
    expect(page).to have_content invitation_to_tender.project_owners_company_name
    expect(page).to have_content invitation_to_tender.contract_class
    expect(page).to have_content invitation_to_tender.project_location
    expect(page).to have_content invitation_to_tender.project_currency

    expect(page).to have_content invitation_to_tender.time_to_deadline
    expect(page).to have_content invitation_to_tender.project_deadline.to_formatted_s(:long)

    expect(page).to have_content invitation_to_tender.project_description

    invitation_to_tender.required_documents.each do |required_document|
      expect(page).to have_content required_document.title
    end

    expect(page).to have_content invitation_to_tender.tender_instructions
  end
end
