# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Product walkthrough', js: true do
  include RequestForTendersHelper

  xscenario 'should publish a public request for tender successfully' do
    # Capybara.app_host = 'https://app.tenderswift.com'
    # Capybara.run_server = false
    # Capybara.default_max_wait_time = 90

    given_a_publisher_has_logged_in
    and_has_created_a_request_for_tender
    and_has_added_the_general_information
    and_has_uploaded_the_bill_of_quantities
    and_has_uploaded_the_tender_documents
    and_has_added_the_tendering_instructions
    and_has_added_the_distribution_information

    when_they_publish_the_tender

    then_it_should_show_as_publishing_on_their_dashboard
    and_it_should_send_an_email_to_alfred
    and_the_request_for_tender_should_show_up_for_review_on_the_admins_dashboard
    and_the_admin_should_be_able_to_edit_it
    and_the_admin_should_be_able_publish_it

    then_the_publisher_should_receive_an_email_that_their_rft_has_been_published
    and_the_rft_should_move_to_the_published_column_of_their_dashboard

    and_they_should_be_able_to_monitor_the_rft
    and_the_request_for_tender_should_have_a_purchase_tender_page

    and_they_should_be_able_to_logout_successfully

    when_a_contractor_signs_up_and_purchases_a_tender

    they_should_show_up_under_purchases_on_the_publishers_monitor_page


    then_they_should_find_the_request_for_tender_in_their_purchased_tenders
    and_they_should_be_able_to_see_the_tenders_general_information
    and_they_should_be_able_to_download_the_tenders_tender_documents

    when_they_try_to_submit_the_tender
    and_they_should_see_boq_rate_errors
    they_should_see_required_document_errors

    and_they_should_be_able_to_fill_rates_in_the_tenders_boq
    and_they_should_be_able_to_upload_the_tenders_required_documents

    and_they_should_be_able_to_submit_their_tender_successfully

    they_should_show_up_under_submissions_on_the_publishers_monitor_page
  end

  def given_a_publisher_has_logged_in
    @new_publisher = FactoryBot.build(
      :publisher,
      email: 'tenderswift_test_procurement_officer+' \
        "#{SecureRandom.urlsafe_base64(6)}@gmail.com".downcase
    )

    visit new_publisher_registration_path

    fill_in 'Your name', with: @new_publisher.full_name
    fill_in 'Email address', with: @new_publisher.email
    fill_in 'Phone number', with: @new_publisher.phone_number
    fill_in 'Company name', with: @new_publisher.company_name
    attach_file('Company logo', Rails.root + 'spec/fixtures/company_logo.png')
    fill_in 'Password', with: @new_publisher.password
    fill_in 'Password confirmation', with: @new_publisher.password

    click_button 'Sign up'

    should_have_dashboard_content_for @new_publisher
    expect(page)
      .to have_content 'Welcome! You have signed up successfully.'

    click_link 'Account Information'

    expect(page).to have_content 'Account Information'

    expect(page).to have_field 'Full name',
                               with: @new_publisher.full_name

    expect(page).to have_field 'Email',
                               with: @new_publisher.email

    expect(page).to have_field 'Phone number',
                               with:  @new_publisher.phone_number

    expect(page).to have_field 'Company name',
                               with: @new_publisher.company_name

    expect(page).to have_css('#company_logo_image')
  end

  def and_has_created_a_request_for_tender
    visit publisher_root_path
    expect(page).to have_content 'Create Request For Tender'

    click_button 'Create Request For Tender'
    expect(page).to have_content 'Untitled Project #'
  end

  def and_has_added_the_general_information
    @request_for_tender = FactoryBot.build(
      :request_for_tender,
      publisher: @new_publisher,
      selling_price: 1
    )

    fill_in 'Project name', with: @request_for_tender.project_name

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
    expect(page).to have_link 'uploaded-boq', wait: 60
    click_button 'Next', match: :first
  end

  def and_has_uploaded_the_tender_documents
    attach_file(
      'request_for_tender_project_documents_attributes_0_document',
      Rails.root + 'spec/fixtures/Contract Documents.doc'
    )
    click_button 'Save', match: :first

    expect(page).to have_link 'request_for_tender_project_document_0', wait: 60
    click_button 'Next', match: :first
  end

  def and_has_added_the_tendering_instructions
    editor = page.find(:css, '.trix-content')
    editor.click.set(@request_for_tender.tender_instructions)
    click_button 'Next', match: :first
  end

  def and_has_added_the_distribution_information
    fill_in 'Selling price', with: @request_for_tender.selling_price
    fill_in 'Bank name', with: @request_for_tender.bank_name
    fill_in 'Branch name', with: @request_for_tender.branch_name
    fill_in 'Account name', with: @request_for_tender.account_name
    fill_in 'Account number', with: @request_for_tender.account_number
    select 'Every two weeks', from: 'Withdrawal frequency'
    click_button 'Next', match: :first
  end

  def when_they_publish_the_tender
    @request_for_tender.id = find_field('request_for_tender_reference_number')
                             .value.to_i

    accept_confirm do
      click_button 'Publish', match: :first
    end
  end

  def and_they_should_be_able_to_monitor_the_rft
    should_have_content_of_request_for_tender
  end

  def and_the_request_for_tender_should_have_a_purchase_tender_page
    new_window = window_opened_by { click_link :purchase_link }
    within_window new_window do
      should_have_content_of_request_for_tender
    end
  end

  def and_the_rft_should_move_to_the_published_column_of_their_dashboard
    visit publisher_root_path

    within :css, '#published-request-for-tenders' do
      expect(page).to have_content @request_for_tender.project_name
      expect(page).to have_content project_location @request_for_tender
      expect(page).to have_content time_to_deadline @request_for_tender
    end
  end

  def and_they_should_be_able_to_logout_successfully
    visit publisher_root_path

    click_link @new_publisher.company_name
    click_link 'Logout'

    should_see_publisher_sign_in_page
  end

  # Contractor methods

  def when_a_contractor_signs_up_and_purchases_a_tender
    @new_contractor = FactoryBot.build(
      :contractor,
      email: 'tenderswift_test_contractor+' \
        "#{SecureRandom.urlsafe_base64(6)}@gmail.com".downcase
    )

    visit new_contractor_registration_path

    fill_in 'Your name', with: @new_contractor.full_name
    fill_in 'Email address', with: @new_contractor.email
    fill_in 'Phone number', with: @new_contractor.phone_number
    fill_in 'Company name', with: @new_contractor.company_name
    attach_file('Company logo', Rails.root + 'spec/fixtures/company_logo.png')
    fill_in 'Password', with: @new_contractor.password
    fill_in 'Password confirmation', with: @new_contractor.password

    click_button 'Sign up'

    should_have_contractor_dashboard_content_for @new_contractor
    expect(page)
      .to have_content 'Welcome! You have signed up successfully.'

    click_link 'Account Information'

    expect(page).to have_content 'Account Information'

    expect(page).to have_field 'Full name',
                               with: @new_contractor.full_name

    expect(page).to have_field 'Email',
                               with: @new_contractor.email

    expect(page).to have_field 'Phone number',
                               with: @new_contractor.phone_number

    expect(page).to have_field 'Company name',
                               with: @new_contractor.company_name

    expect(page).to have_css('#company_logo_image')

    @signed_up_contractor = @new_contractor
  end

  def when_they_purchase_a_tender
    @invitation_to_tender = @request_for_tender

    visit purchase_tender_path @invitation_to_tender

    click_button id: 'purchase-button'

    within :css, '#paymentModal' do
      select 'Vodafone Cash', from: 'Mode of payment'
      fill_in 'Mobile money number', with: '0500011505'
      fill_in 'Voucher code', with: '123456'
      click_button 'Purchase'
    end

    # within :css, '#paymentModal' do
    #   select 'MTN Mobile Money', from: 'Mode of payment'
    #   fill_in 'Mobile money number', with: '0546639821'
    #   click_button 'Purchase'
    # end

    expect(page).to have_current_path(contractor_root_path, wait: 40)
  end

  def then_they_should_find_the_request_for_tender_in_their_purchased_tenders
    within :css, '#purchased-tenders' do
      expect(page).to have_content @invitation_to_tender.project_name
    end
  end

  def and_they_should_be_able_to_see_the_tenders_general_information
    user_sees_public_request_for_tender_information(@request_for_tender)
  end

  def and_they_should_be_able_to_download_the_tenders_tender_documents
    click_link '2. Tender Documents'

    @request_for_tender.project_documents.each do |project_document|
      expect(page).to have_content project_document.document.file.filename
      expect(page).to have_link 'Download', href: project_document.document.url
    end
  end

  def and_they_should_be_able_to_fill_rates_in_the_tenders_boq
    click_link '3. Bill of Quantities'

    within :css, '#hello' do
      # TODO: Check for display of BOQ
      # expect(page.find('rate-filling-boq')[':workbook-data'])
      #   .to eq(@tender.workbook)
    end
  end

  def and_they_should_be_able_to_upload_the_tenders_required_documents
    click_link '4. Upload Documents'

    @request_for_tender.required_documents.each do |required_documents|
      expect(page).to have_content required_documents.title
    end
  end

  def they_should_show_up_under_purchases_on_the_publishers_monitor_page
    click_link @signed_up_contractor.company_name
    click_link 'Logout'

    should_see_contractor_sign_in_page

    visit new_publisher_session_path
    fill_in 'Email address', with: @new_publisher.email
    fill_in 'Password', with: @new_publisher.password
    click_button 'Log in'

    expect(page).to have_content @new_publisher.company_name

    click_link @invitation_to_tender.project_name

    click_link 'Purchased'

    within(:css, '#collapsePurchasedContractors') do
      expect(page).to have_content @signed_up_contractor.company_name
      expect(page).to have_content @signed_up_contractor.email
    end
  end

  private

  def should_have_dashboard_content_for(publisher)
    expect(page).to have_content 'Home'
    expect(page).to have_content publisher.company_name
    click_link publisher.company_name
    expect(page).to have_content 'Account Information'
    expect(page).to have_content 'Logout'
    expect(page).to have_content 'Unpublished Request For Tender'
    expect(page).to have_content 'Published Requests For Tender'
    expect(page).to have_content 'Closed Tenders'
  end

  def should_have_content_of_request_for_tender
    user_sees_public_request_for_tender_information(@request_for_tender)
  end

  def should_see_publisher_sign_in_page
    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Log in as a publisher'
    expect(page).to have_content 'or sign up'
    expect(page).to have_content 'Log in'
  end

  def should_see_contractor_sign_in_page
    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Log in as a contractor'
    expect(page).to have_content 'or sign up'
    expect(page).to have_content 'Log in'
  end

  def should_have_contractor_dashboard_content_for(contractor)
    expect(page).to have_content 'Home'
    expect(page).to have_content contractor.company_name
    click_link contractor.company_name
    expect(page).to have_content 'Account Information'
    expect(page).to have_content 'Logout'
    expect(page).to have_content 'Invitations To Tender'
    expect(page).to have_content 'Purchased Tenders'
    expect(page).to have_content 'Submitted Tenders'
  end
end
