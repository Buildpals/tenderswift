# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Creating request for tender' do
  let!(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }
  let!(:request_for_tender) { FactoryBot.build(:request_for_tender) }
  include RequestForTendersHelper

  background do
    login_as(quantity_surveyor, scope: :quantity_surveyor)
  end

  scenario 'A quantity surveyor can publish a public request for tender successfully' do
    create_request_for_tender
    should_see_new_request_for_tender_in_dashboard

    go_to_project_information_page
    fill_in_project_information

    go_to_bill_of_quantities_page
    upload_bill_of_quantities

    go_to_tender_documents_page
    upload_tender_documents

    go_to_tender_instructions_page
    upload_tender_instructions

    go_to_payment_method_page
    fill_in_payment_method_information

    go_to_distribution_page
    publish_as_public_request_for_tender

    quantity_surveyor_should_see_request_for_tender_on_monitor_page
    contractor_should_see_invitation_to_tender_on_purchase_page
  end

  scenario 'A quantity surveyor can publish a private request for tender successfully' do
    create_request_for_tender
    should_see_new_request_for_tender_in_dashboard

    go_to_project_information_page
    fill_in_project_information

    go_to_bill_of_quantities_page
    upload_bill_of_quantities

    go_to_tender_documents_page
    upload_tender_documents

    go_to_tender_instructions_page
    upload_tender_instructions

    go_to_payment_method_page
    fill_in_payment_method_information

    go_to_distribution_page
    publish_as_private_request_for_tender

    quantity_surveyor_should_see_request_for_tender_on_monitor_page
    contractor_should_see_invitation_to_tender_on_purchase_page
    contractor_should_see_invitation_to_tender_on_their_dashboard
  end

  def should_see_new_request_for_tender_in_dashboard
    # code here
  end

  def go_to_project_information_page
    # code here
  end

  def fill_in_project_information
    fill_in 'Project name', with: request_for_tender.project_name
    select 'GHS - Ghanaian Cedi', from: 'Currency'

    select '10', from: 'request_for_tender_deadline_3i'
    select 'May', from: 'request_for_tender_deadline_2i'
    select '2018', from: 'request_for_tender_deadline_1i'
    select '3 PM', from: 'request_for_tender_deadline_4i'
    select '00', from: 'request_for_tender_deadline_5i'

    select 'Ghana', from: 'Country'
    fill_in 'City', with: request_for_tender.city

    fill_in 'Description', with: request_for_tender.description
  end

  def create_request_for_tender
    visit quantity_surveyor_root_path
    expect(page).to have_content 'Create Request For Tender'

    click_link 'Create Request For Tender'
    expect(page).to have_content 'Untitled Project #'
    expect(page).to have_content 'General Information'
  end

  def upload_bill_of_quantities
    # TODO: 'Upload Bill of Quantities. Requires javascript'
    # attach_file('Upload', Rails.root + 'spec/fixtures/bill_of_quantities.xlsx')

    # TODO: 'Check that tender figure for Bill of Quantities is correct'
  end

  def go_to_bill_of_quantities_page
    go_to_next_page
    expect(page).to have_content 'Bill Of Quantities'
  end

  def go_to_tender_documents_page
    go_to_next_page
    expect(page).to have_content 'Tender Documents'
  end

  def upload_tender_documents
    skip 'Spec not finished'

    page.all(:css, '.nested-fields').each do |el|
      within el do
        attach_file('input', Rails.root + 'spec/fixtures/bill_of_quantities.xlsx')
      end
    end

    # TODO: Upload tender documents
  end

  def go_to_tender_instructions_page
    go_to_next_page
    expect(page).to have_content 'Tender Instructions'
  end

  def upload_tender_instructions
    skip 'Spec not finished'

    # TODO: Fill in tender instructions
  end

  def go_to_payment_method_page
    go_to_next_page
    expect(page).to have_content 'Payment Method'
  end

  def fill_in_payment_method_information
    fill_in 'Selling price', with: request_for_tender.selling_price
    fill_in 'Bank name', with: request_for_tender.bank_name
    fill_in 'Branch name', with: request_for_tender.branch_name
    fill_in 'Account name', with: request_for_tender.account_name
    fill_in 'Account number', with: request_for_tender.account_number
    select 'Every two weeks', from: 'Withdrawal frequency'
  end

  def go_to_distribution_page
    go_to_next_page
    expect(page).to have_content 'Distribution'
  end

  def publish_as_public_request_for_tender
    within '.top-navigation' do
      click_button 'Publish'
    end
  end

  def publish_as_private_request_for_tender
    skip 'Spec not finished'

    check('Limit access to portal')


    # TODO: Add contractors to request for tender
    within '.top-navigation' do
      click_button 'Publish'
    end
  end

  def quantity_surveyor_should_see_request_for_tender_on_monitor_page
    expect(page).to have_content request_for_tender.project_name
    expect(page).to have_content contract_class @request_for_tender
    expect(page).to have_content project_location request_for_tender
    expect(page).to have_content project_currency request_for_tender

    expect(page).to have_content time_to_deadline request_for_tender

    expect(page).to have_content 'May 10, 2018 15:00'
    expect(page).to have_content request_for_tender.description

    request_for_tender.required_documents.each do |required_document|
      expect(page).to have_content required_document.title
    end

    skip 'Spec not finished'
    # TODO: expect(page).to have_content request_for_tender.tender_instructions
  end

  def contractor_should_see_invitation_to_tender_on_purchase_page

    skip 'Spec not finished'
    # TODO: code here
  end

  def contractor_should_see_invitation_to_tender_on_their_dashboard

    skip 'Spec not finished'
    # TODO: code here
  end

  private

  def go_to_next_page
    within '.top-navigation' do
      click_button 'Next'
    end
  end
end
