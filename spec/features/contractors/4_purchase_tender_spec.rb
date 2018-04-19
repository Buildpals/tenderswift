# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Purchasing a tender' do
  include RequestForTendersHelper

  scenario 'should allow signing up and purchasing a tender simultaneously' do
    given_a_new_contractor_who_has_not_signed_up_before
    when_they_sign_up_and_purchase_a_tender_simultaneously
    then_they_should_find_the_request_for_tender_in_their_purchased_tenders
    and_they_should_be_able_to_see_the_tenders_general_information
    and_they_should_be_able_to_see_the_tenders_tender_documents
    and_they_should_be_able_to_see_the_tenders_boq
    and_they_should_be_able_to_see_the_tenders_required_documents
    and_they_should_show_up_under_purchased_on_the_quantity_surveyors_dashboard
  end

  scenario 'should allow logging in and purchasing a tender simultaneously' do
    given_an_existing_contractor_who_has_not_logged_in_yet
    when_they_login_and_purchase_a_tender_simultaneously
    then_they_should_find_the_request_for_tender_in_their_purchased_tenders
    and_they_should_be_able_to_see_the_tenders_general_information
    and_they_should_be_able_to_see_the_tenders_tender_documents
    and_they_should_be_able_to_see_the_tenders_boq
    and_they_should_be_able_to_see_the_tenders_required_documents
    and_they_should_show_up_under_purchased_on_the_quantity_surveyors_dashboard
  end

  scenario 'should allow purchasing a tender when you\'re already logged in' do
    given_a_contractor_has_logged_in
    when_they_purchase_a_tender
    then_they_should_find_the_request_for_tender_in_their_purchased_tenders
    and_they_should_be_able_to_see_the_tenders_general_information
    and_they_should_be_able_to_see_the_tenders_tender_documents
    and_they_should_be_able_to_see_the_tenders_boq
    and_they_should_be_able_to_see_the_tenders_required_documents
    and_they_should_show_up_under_purchased_on_the_quantity_surveyors_dashboard
  end

  def given_a_new_contractor_who_has_not_signed_up_before
    @new_contractor = FactoryBot.build(:contractor)
  end

  def given_an_existing_contractor_who_has_not_logged_in_yet
    @signed_up_contractor = FactoryBot.create(:contractor)
  end

  def given_a_contractor_has_logged_in
    @signed_up_contractor = FactoryBot.create(:contractor)
    login_as(@signed_up_contractor, scope: :contractor)
  end

  def when_they_sign_up_and_purchase_a_tender_simultaneously
    @invitation_to_tender = FactoryBot.create(:request_for_tender)

    visit purchase_tender_path @invitation_to_tender
    fill_in :signup_company_name, with: @new_contractor.company_name
    fill_in :signup_phone_number, with: @new_contractor.phone_number
    fill_in :signup_email, with: @new_contractor.email
    fill_in :signup_password, with: @new_contractor.password
    select 'MTN Mobile Money', from: :signup_network_code
    fill_in :signup_customer_number, with: @new_contractor.phone_number
    fill_in :signup_vodafone_voucher_code, with: '123456'
    click_button 'Sign up and Purchase'

    @signed_up_contractor = Contractor.find_by(email: @new_contractor.email)
  end


  def when_they_login_and_purchase_a_tender_simultaneously
    @invitation_to_tender = FactoryBot.create(:request_for_tender)

    visit purchase_tender_path @invitation_to_tender
    fill_in :login_email, with: @signed_up_contractor.email
    fill_in :login_password, with: @signed_up_contractor.password
    select 'MTN Mobile Money', from: :login_network_code
    fill_in :login_customer_number, with: @signed_up_contractor.phone_number
    fill_in :login_vodafone_voucher_code, with: '123456'
    click_button 'Log in and Purchase'
  end

  def when_they_purchase_a_tender
    @invitation_to_tender = FactoryBot.create(:request_for_tender)

    visit purchase_tender_path @invitation_to_tender
    select 'MTN Mobile Money', from: :network_code
    fill_in :customer_number, with: @signed_up_contractor.phone_number
    fill_in :vodafone_voucher_code, with: '123456'
    click_button 'Purchase'
  end

  def then_they_should_find_the_request_for_tender_in_their_purchased_tenders
    within :css, '#purchased-tenders' do
      expect(page).to have_content @invitation_to_tender.project_name
    end
  end

  def and_they_should_be_able_to_see_the_tenders_general_information
    @tender = Tender.find_by(request_for_tender: @invitation_to_tender,
                             contractor: @signed_up_contractor)

    click_link @tender.project_name

    expect(page).to have_content @tender.project_name
    expect(page).to have_content @tender.project_owners_company_name
    expect(page).to have_content contract_class @tender
    expect(page).to have_content project_location @tender
    expect(page).to have_content project_currency @tender

    expect(page).to have_content time_to_deadline @tender
    expect(page).to have_content @tender.deadline.to_formatted_s(:long)

    expect(page).to have_content @tender.description

    @tender.required_documents.each do |required_document|
      expect(page).to have_content required_document.title
    end

    expect(page).to have_content @tender.tender_instructions
  end

  def and_they_should_be_able_to_see_the_tenders_tender_documents
    click_link '2. Tender Documents'

    @tender.project_documents.each do |project_document|
      expect(page).to have_content project_document.document.file.filename
      expect(page).to have_link 'Download', href: project_document.document.url
    end
  end

  def and_they_should_be_able_to_see_the_tenders_boq
    click_link '3. Bill of Quantities'

    expect(page.find('rate-filling-boq')[':workbook-data'])
      .to eq(@tender.workbook)
  end

  def and_they_should_be_able_to_see_the_tenders_required_documents
    click_link '4. Upload Documents'

    @tender.required_documents.each do |required_documents|
      expect(page).to have_content required_documents.title
    end
  end

  def and_they_should_show_up_under_purchased_on_the_quantity_surveyors_dashboard
    logout(@signed_up_contractor, scope: :contractor)

    login_as(@invitation_to_tender.quantity_surveyor, scope: :quantity_surveyor)

    visit request_for_tender_path @invitation_to_tender

    within(:css, '#collapsePurchasedContractors', visible: :all) do
      expect(page).to have_content @signed_up_contractor.company_name
      expect(page).to have_content @signed_up_contractor.email
    end
  end
end
