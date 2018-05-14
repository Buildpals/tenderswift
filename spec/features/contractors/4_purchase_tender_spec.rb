# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Purchasing a tender' do
  include RequestForTendersHelper

  context 'Invitation to tender has already been purchased already' do
    scenario 'should redirect to contractors home page with notice' do
      given_a_contractor_has_logged_in
      and_they_have_purchased_a_particular_tender
      when_they_go_to_the_purchase_tender_page_for_that_particular_tender
      then_they_should_be_redirected_to_their_dashboard
      and_they_should_be_told_they_have_already_purchased_this_tender
    end
  end

  context 'Invitation to tender has not been purchased alread' do
    xscenario 'should allow signing up and purchasing a tender simultaneously' do
      skip 'Not implemented'
    end

    xscenario 'should allow logging in and purchasing a tender simultaneously' do
      skip 'Not implemented'
    end

    scenario 'should allow purchasing a tender', js: true do
      Capybara.current_driver = :selenium

      given_a_contractor_has_logged_in
      when_they_purchase_a_tender
      then_they_should_find_the_request_for_tender_in_their_purchased_tenders
      and_they_should_be_able_to_see_the_tenders_general_information
      and_they_should_be_able_to_see_the_tenders_tender_documents
      and_they_should_be_able_to_see_the_tenders_boq
      and_they_should_be_able_to_see_the_tenders_required_documents
      and_they_should_show_up_under_purchased_on_the_quantity_surveyors_dashboard

      Capybara.use_default_driver
    end
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

  def when_they_purchase_a_tender
    @invitation_to_tender = FactoryBot.create(:request_for_tender)

    visit purchase_tender_path @invitation_to_tender

    click_button id: 'purchase-button'

    within :css, '#paymentModal' do
      select 'Vodafone Cash', from: 'Mode of payment'
      fill_in 'Mobile money number', with: @signed_up_contractor.phone_number
      fill_in 'Voucher code', with: '123456'
      click_button 'Purchase'
    end
  end

  def then_they_should_find_the_request_for_tender_in_their_purchased_tenders
    expect(page).to have_current_path(contractor_root_path, wait: 40)

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

    @tender.request_for_tender.required_documents.each do |required_document|
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

    within :css, '#hello' do
      # TODO: Check for display of BOQ
      # expect(page.find('rate-filling-boq')[':workbook-data'])
      #   .to eq(@tender.workbook)
    end
  end

  def and_they_should_be_able_to_see_the_tenders_required_documents
    click_link '4. Upload Documents'

    @tender.request_for_tender.required_documents.each do |required_documents|
      expect(page).to have_content required_documents.title
    end
  end

  def and_they_should_show_up_under_purchased_on_the_quantity_surveyors_dashboard
    logout(@signed_up_contractor, scope: :contractor)

    login_as(@invitation_to_tender.quantity_surveyor, scope: :quantity_surveyor)

    visit request_for_tender_path @invitation_to_tender

    click_link 'Purchased'

    within(:css, '#collapsePurchasedContractors') do
      expect(page).to have_content @signed_up_contractor.company_name
      expect(page).to have_content @signed_up_contractor.email
    end
  end

  def and_they_have_purchased_a_particular_tender
    @invitation_to_tender = FactoryBot.create(:request_for_tender)
    FactoryBot.create(:tender,
                      :purchased,
                      request_for_tender: @invitation_to_tender,
                      contractor: @signed_up_contractor)
  end

  def when_they_go_to_the_purchase_tender_page_for_that_particular_tender
    visit purchase_tender_path @invitation_to_tender
  end

  def then_they_should_be_redirected_to_their_dashboard
    expect(page).to have_content 'Purchased Tenders'
    within :css, '#purchased-tenders' do
      expect(page).to have_content @invitation_to_tender.project_name
    end
  end

  def and_they_should_be_told_they_have_already_purchased_this_tender
    expect(page).to have_content 'You have already purchased this tender'
  end
end
