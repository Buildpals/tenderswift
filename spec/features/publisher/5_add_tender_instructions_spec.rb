# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Create request for tender', js: true do
  let!(:publisher) { FactoryBot.create(:publisher) }
  let!(:tender_instructions) { FactoryBot.build(:request_for_tender) }

  let!(:request_for_tender) do
    FactoryBot.create(:empty_request_for_tender,
                      publisher: publisher)
  end

  scenario 'should remove a required document for a request for tender' do
    given_a_publisher_who_has_logged_in
    visit request_for_tender_build_path(request_for_tender, :tender_instructions)
    click_link 'Add another required document'
    fill_in placeholder: 'Title of document', with: 'Tax Clearance Certificate'

    find('input[name="commit"]').click
    expect(page).to have_content('Your changes have been saved!')
  end

  scenario 'should display next step of create request for tender wizard' do
    given_a_publisher_who_has_logged_in
    visit request_for_tender_build_path(request_for_tender, :tender_instructions)
    find('input[name="commit"]').click
    expect(page).to have_current_path(request_for_tender_build_path(request_for_tender,
                                                                    :distribution))
    expect(page).to have_content 'Tender fee'
  end

  scenario 'should display previous step of create request for tender wizard' do
    given_a_publisher_who_has_logged_in
    visit request_for_tender_build_path(request_for_tender, :tender_instructions)
    click_link 'Previous'

    expect(page).to have_current_path(
                        request_for_tender_build_path(request_for_tender,
                                                      :tender_documents)
                    )
  end
end

def given_a_publisher_who_has_logged_in
  login_as publisher, scope: :publisher
end

def then_it_should_save_the_tender_instructions(request_for_tender,
                                                tender_instructions)
  visit request_for_tender_build_path(request_for_tender,
                                      :tender_instructions)

  editor = page.find(:css, '.trix-content')
  expect(editor.value).to include tender_instructions.tender_instructions
end
