# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Create request for tender', js: true do
  let!(:publisher) { FactoryBot.create(:publisher) }
  let!(:request_for_tender) do
    FactoryBot.create(:empty_request_for_tender,
                      publisher: publisher)
  end

  scenario 'should save the tender documents of a request for tender' do
    given_a_publisher_who_has_logged_in

    when_they_upload_the_tender_documents_for_an_rft(request_for_tender)

    then_it_should_save_the_tender_documents(request_for_tender)
  end

  scenario 'should should display step four of wizard when publisher clicks
            save and continue' do
    given_a_publisher_who_has_logged_in
    when_they_upload_the_tender_documents_for_an_rft(request_for_tender)
    click_link 'Save and continue', match: :first
    expect(page).to have_current_path(request_for_tender_build_path(request_for_tender,
                                                                    :tender_instructions))
    expect(page).to have_content 'Please add the documents you want the
                                  contractor to submit as part of their tender'
  end
end

def given_a_publisher_who_has_logged_in
  login_as publisher, scope: :publisher
end

def when_they_upload_the_tender_documents_for_an_rft(request_for_tender)
  visit request_for_tender_build_path(request_for_tender, :tender_documents)

  attach_file('project_document[document]',
              Rails.root + 'spec/fixtures/Contract Documents.doc',
              visible: false)

  within :css, '#project-documents-container' do
    expect(page).to have_link 'Contract Documents.doc', wait: 10
  end
end

def then_it_should_save_the_tender_documents(request_for_tender)
  visit request_for_tender_build_path(request_for_tender,
                                      :tender_documents)

  within :css, '#project-documents-container' do
    expect(page).to have_link 'Contract Documents.doc', wait: 10
  end
end