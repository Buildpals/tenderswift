# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Create request for tender', js: true do
  include RequestForTendersHelper

  scenario 'should publish a public request for tender successfully' do
    given_a_quantity_surveyor_has_logged_in
    and_has_created_a_request_for_tender
    and_has_added_the_general_information
    and_has_uploaded_the_bill_of_quantities
    and_has_uploaded_the_tender_documents
    and_has_added_the_tendering_instructions
    and_has_added_the_payment_information

    when_they_publish_it_as_a_public_tender

    then_it_should_take_them_to_the_monitor_request_for_tender_page
    and_the_request_for_tender_should_have_a_purchase_tender_page
    and_the_request_for_tender_should_appear_in_their_published_tenders
  end

  def given_a_quantity_surveyor_has_logged_in
    @quantity_surveyor = FactoryBot.create(:quantity_surveyor)
    login_as @quantity_surveyor, scope: :quantity_surveyor
  end

  def and_has_created_a_request_for_tender
    visit quantity_surveyor_root_path
    expect(page).to have_content 'Create Request For Tender'

    click_button 'Create Request For Tender'
    expect(page).to have_content 'Untitled Project #'
  end

  def and_has_added_the_general_information
    @request_for_tender = FactoryBot.build(:request_for_tender)

    fill_in 'Project name', with: @request_for_tender.project_name
    select 'GHS - Ghanaian Cedi', from: 'Currency'

    select @request_for_tender.deadline.strftime('%-d'),
           from: 'request_for_tender_deadline_3i'

    select @request_for_tender.deadline.strftime('%B'),
           from: 'request_for_tender_deadline_2i'

    select @request_for_tender.deadline.strftime('%Y'),
           from: 'request_for_tender_deadline_1i'

    select "#{@request_for_tender.deadline.strftime('%I')} " \
           "#{@request_for_tender.deadline.strftime('%p')}",
           from: 'request_for_tender_deadline_4i'

    select @request_for_tender.deadline.strftime('%M'),
           from: 'request_for_tender_deadline_5i'

    select 'Ghana', from: 'Country'
    fill_in 'City', with: @request_for_tender.city

    fill_in 'Description', with: @request_for_tender.description
    click_button 'Next', match: :first
  end

  def and_has_uploaded_the_bill_of_quantities
    attach_file('upload-boq',
                Rails.root + 'spec/fixtures/bill_of_quantities.xlsx')
    expect(page).to have_link 'uploaded-boq', wait: 10
    click_button 'Next', match: :first
  end

  def and_has_uploaded_the_tender_documents
    attach_file(
      'request_for_tender_project_documents_attributes_0_document',
      Rails.root + 'spec/fixtures/Contract Documents.doc'
    )
    click_button 'Next', match: :first
  end

  def and_has_added_the_tendering_instructions
    editor = page.find(:css, '.trix-content')
    editor.click.set(@request_for_tender.tender_instructions)
    click_button 'Next', match: :first
  end

  def and_has_added_the_payment_information
    fill_in 'Selling price', with: @request_for_tender.selling_price
    fill_in 'Bank name', with: @request_for_tender.bank_name
    fill_in 'Branch name', with: @request_for_tender.branch_name
    fill_in 'Account name', with: @request_for_tender.account_name
    fill_in 'Account number', with: @request_for_tender.account_number
    select 'Every two weeks', from: 'Withdrawal frequency'
    click_button 'Next', match: :first
  end

  def when_they_publish_it_as_a_public_tender
    accept_confirm do
      click_button 'Publish', match: :first
    end
  end

  def when_they_publish_it_as_a_private_tender
    check('Limit access to portal')

    fill_in 'request_for_tender[contractors_attributes][0][company_name]',
            with: contractor.company_name
    fill_in 'request_for_tender[contractors_attributes][0][email]',
            with: contractor.email
    fill_in 'request_for_tender[contractors_attributes][0][phone_number]',
            with: contractor.phone_number

    within '.top-navigation' do
      click_button 'Publish'
    end
  end

  def then_it_should_take_them_to_the_monitor_request_for_tender_page
    should_have_content_of_request_for_tender
  end

  def and_the_request_for_tender_should_have_a_purchase_tender_page
    click_link :public_web_address
    should_have_content_of_request_for_tender
  end

  def and_the_request_for_tender_should_appear_in_their_published_tenders
    visit quantity_surveyor_root_path

    within :css, '#published-request-for-tenders' do
      expect(page).to have_content @request_for_tender.project_name
      expect(page).to have_content project_location @request_for_tender
      expect(page).to have_content time_to_deadline @request_for_tender
    end
  end

  private

  def should_have_content_of_request_for_tender
    expect(page).to have_content @request_for_tender.project_name
    expect(page).to have_content contract_class @request_for_tender
    expect(page).to have_content project_location @request_for_tender
    expect(page).to have_content project_currency @request_for_tender

    expect(page).to have_content time_to_deadline @request_for_tender

    expect(page).to have_content @request_for_tender.deadline.to_formatted_s(:long)
    expect(page).to have_content @request_for_tender.description

    @request_for_tender.required_documents.each do |required_document|
      expect(page).to have_content required_document.title
    end

    expect(page).to have_content @request_for_tender.tender_instructions
  end
end
