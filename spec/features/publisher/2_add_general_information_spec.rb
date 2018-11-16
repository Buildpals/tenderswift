# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Create request for tender', js: true do
  let!(:publisher) { FactoryBot.create(:publisher) }
  let!(:general_information) { FactoryBot.build(:request_for_tender) }

  let!(:empty_request_for_tender) do
    FactoryBot.create(:empty_request_for_tender,
                      publisher: publisher)
  end

  let!(:filled_request_for_tender) do
    FactoryBot.create(:request_for_tender, :not_submitted, :not_published,
                      publisher: publisher)
  end

  scenario 'should save the general information of a request for tender' do
    given_a_publisher_who_has_logged_in

    when_they_add_the_general_information_for_an_rft(empty_request_for_tender,
                                                     general_information)

    #then_it_should_save_the_general_information(empty_request_for_tender,
    #                                            general_information)
  end

  scenario 'should display next step in create request for tender wizard' do
    given_a_publisher_who_has_logged_in

    visit request_for_tender_build_path(filled_request_for_tender,
                                        :general_information)

    click_button 'Submit', match: :first

    click_button 'Save and continue', match: :first

    expect(page).to have_current_path(
                        request_for_tender_build_path(filled_request_for_tender,
                                                      :bill_of_quantities)
                    )
  end

  scenario 'should vote on when next his request for tender will be' do
    given_a_publisher_who_has_logged_in

    visit request_for_tender_build_path(filled_request_for_tender,
                                        :general_information)

    expect(page).to have_content 'Claim your free request for tenders'

    click_button 'Submit', match: :first

    expect(page).to have_content 'Thank you. ' \
                                'A message with a confirmation link ' \
                                'has been sent to your email address. Please open the ' \
                                'link to set a password for your account.'


  end
end

def given_a_publisher_who_has_logged_in
  login_as publisher, scope: :publisher
end

def when_they_add_the_general_information_for_an_rft(request_for_tender,
                                                     general_information)
  visit request_for_tender_build_path(request_for_tender,
                                      :general_information)

  click_button 'Submit', match: :first

  fill_in 'Name', with: general_information.project_name

  select general_information.deadline.strftime('%-d'),
         from: 'request_for_tender_deadline_3i'

  select general_information.deadline.strftime('%B'),
         from: 'request_for_tender_deadline_2i'

  select general_information.deadline.strftime('%Y'),
         from: 'request_for_tender_deadline_1i'

  select "#{general_information.deadline.strftime('%I')} " \
           "#{general_information.deadline.strftime('%p')}",
         from: 'request_for_tender_deadline_4i'

  select general_information.deadline.strftime('%M'),
         from: 'request_for_tender_deadline_5i'

  select 'Ghana', from: 'Country'
  fill_in 'City', with: general_information.city

  editor = page.find(:css, '.trix-content')
  editor.click.set(general_information.description)
  click_button 'Save and continue', match: :first

  expect(page).to have_content 'Your changes have been saved!'
end

def then_it_should_save_the_general_information(request_for_tender,
                                                general_information)
  visit request_for_tender_build_path(request_for_tender,
                                      :general_information)

  expect(page).to have_field 'Name',
                             with: general_information.project_name

  expect(page)
    .to have_select 'request_for_tender_deadline_3i',
                    selected: general_information.deadline.strftime('%-d')

  expect(page)
    .to have_select 'request_for_tender_deadline_2i',
                    selected: general_information.deadline.strftime('%B')

  expect(page)
    .to have_select 'request_for_tender_deadline_1i',
                    selected: general_information.deadline.strftime('%Y')

  expect(page)
    .to have_select 'request_for_tender_deadline_4i',
                    selected: "#{general_information.deadline.strftime('%I')}" \
                              " #{general_information.deadline.strftime('%p')}"

  expect(page)
    .to have_select 'request_for_tender_deadline_5i',
                    selected: general_information.deadline.strftime('%M')

  expect(page).to have_select 'Country', selected: 'Ghana'

  expect(page).to have_field 'City',
                             with: general_information.city

  editor = page.find(:css, '.trix-content')

  expect(editor.value).to include general_information.description
end
