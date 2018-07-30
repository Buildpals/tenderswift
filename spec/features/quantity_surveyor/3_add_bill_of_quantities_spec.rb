# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Create request for tender', js: true do
  let!(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }
  let!(:request_for_tender) do
    FactoryBot.create(:empty_request_for_tender,
                      quantity_surveyor: quantity_surveyor)
  end

  scenario 'should save the bill of quantities of a request for tender' do
    skip 'Spec not finished'

    given_a_quantity_surveyor_who_has_logged_in

    when_they_upload_the_bill_of_quantities_for_an_rft(request_for_tender)

    then_it_should_save_the_bill_of_quantities(request_for_tender)
  end
end

def given_a_quantity_surveyor_who_has_logged_in
  login_as quantity_surveyor, scope: :quantity_surveyor
end

def when_they_upload_the_bill_of_quantities_for_an_rft(request_for_tender)
  visit request_for_tender_build_path(request_for_tender, :bill_of_quantities)

  find('label', text: 'Upload an excel sheet').click
  attach_file('excel_file_document',
              Rails.root + 'spec/fixtures/bill_of_quantities.xlsx',
              visible: false)

  within :css, '#excel-file-container' do
    expect(page).to have_link 'bill_of_quantities.xlsx', wait: 10
  end
end

def then_it_should_save_the_bill_of_quantities(request_for_tender)
  visit request_for_tender_build_path(request_for_tender,
                                      :bill_of_quantities)

  find('label', text: 'Upload an excel sheet').click

  within :css, '#excel-file-container' do
    expect(page).to have_link 'bill_of_quantities.xlsx'
  end
end
