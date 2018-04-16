# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Purchasing a tender' do
  let!(:invitation_to_tender) { FactoryBot.create(:request_for_tender) }
  let!(:contractor) { FactoryBot.build(:contractor) }
  let!(:signed_up_contractor) { FactoryBot.create(:contractor) }
  include RequestForTendersHelper

  scenario 'A new contractor can sign up and purchase a tender simultaneously' do
    visit purchase_tender_path(invitation_to_tender)

    fill_in_signup_and_purchase_form

    should_find_request_for_tender_in_purchased_tenders

    click_link invitation_to_tender.project_name

    contractor_should_see_invitation_to_tender_content

    skip 'Spec not finished'
    # TODO: check if they show up on the QS dashboard with the right price
    # TODO: check if they can log out and login with the same credentials
  end

  scenario 'An existing contractor can log in and purchase a tender simultaneously' do
    visit purchase_tender_path(invitation_to_tender)

    fill_in :login_email, with: signed_up_contractor.email
    fill_in :login_password, with: signed_up_contractor.password

    select 'MTN Mobile Money', from: :login_network_code
    fill_in :login_customer_number, with: signed_up_contractor.phone_number
    fill_in :login_vodafone_voucher_code, with: '123456'

    click_button 'Log in and Purchase'

    should_find_request_for_tender_in_purchased_tenders

    click_link invitation_to_tender.project_name

    contractor_should_see_invitation_to_tender_content

    skip 'Spec not finished'
    # TODO: Check if they show up on the QS dashboard with the right price
  end

  scenario 'A logged in contractor can purchase a tender' do
    skip 'Not implemented'
  end

  def fill_in_signup_and_purchase_form
    fill_in :signup_company_name, with: contractor.company_name
    fill_in :signup_phone_number, with: contractor.phone_number
    fill_in :signup_email, with: contractor.email
    fill_in :signup_password, with: contractor.password

    select 'MTN Mobile Money', from: :signup_network_code
    fill_in :signup_customer_number, with: contractor.phone_number
    fill_in :signup_vodafone_voucher_code, with: '123456'

    click_button 'Sign up and Purchase'
  end

  def should_find_request_for_tender_in_purchased_tenders
    purchased_tenders_container = page.find('#purchased-tenders')
    expect(purchased_tenders_container).to have_content invitation_to_tender.project_name
  end

  def contractor_should_see_invitation_to_tender_content
    expect(page).to have_content invitation_to_tender.project_name
    expect(page).to have_content invitation_to_tender.project_owners_company_name
    expect(page).to have_content contract_class invitation_to_tender
    expect(page).to have_content project_location invitation_to_tender
    expect(page).to have_content project_currency invitation_to_tender

    expect(page).to have_content time_to_deadline invitation_to_tender
    expect(page).to have_content invitation_to_tender.deadline.to_formatted_s(:long)

    expect(page).to have_content invitation_to_tender.description

    invitation_to_tender.required_documents.each do |required_document|
      expect(page).to have_content required_document.title
    end

    expect(page).to have_content invitation_to_tender.tender_instructions
  end
end
