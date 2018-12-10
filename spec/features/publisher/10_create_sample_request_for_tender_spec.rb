# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Create Sample request for tender' do
  let(:new_publisher) { FactoryBot.create(:publisher, :finished_registration) }

  let(:sample_request_for_tender) { FactoryBot.create(:request_for_tender,
                                                      :sample, publisher: new_publisher)}

  context 'when logged in' do
    background do
      login_as(new_publisher, scope: :publisher)
    end

    scenario 'should create sample request for tender' do

      visit publisher_root_path(new_publisher)

      click_button 'Try TenderSwift'

      expect(page).to have_field 'Name',
                                 with: new_publisher.request_for_tenders
                                           .first.project_name

      expect(page)
          .to have_select 'request_for_tender_deadline_3i',
                          selected: new_publisher.request_for_tenders.first
                                        .deadline.strftime('%-d')

      expect(page)
          .to have_select 'request_for_tender_deadline_2i',
                          selected: new_publisher.request_for_tenders.first
                                        .deadline.strftime('%B')

      expect(page)
          .to have_select 'request_for_tender_deadline_1i',
                          selected: new_publisher.request_for_tenders.first
                                        .deadline.strftime('%Y')

      expect(page)
          .to have_select 'request_for_tender_deadline_4i',
                          selected: "#{new_publisher.request_for_tenders
                                           .first.deadline.strftime('%I')}" \
                              " #{new_publisher.request_for_tenders.first.deadline.strftime('%p')}"

      expect(page)
          .to have_select 'request_for_tender_deadline_5i',
                          selected: new_publisher.request_for_tenders.first
                                        .deadline.strftime('%M')
    end

    scenario 'should go through general information step' do

      visit request_for_tender_build_path(sample_request_for_tender, :general_information)

      click_button 'Save and continue', match: :first

      expect(page).to have_current_path(
                          request_for_tender_build_path(sample_request_for_tender,
                                                        :bill_of_quantities)
                      )

      expect(page).to have_content 'Thank you for using Tenderswift!'
    end

    scenario 'should go through bill of quantity step' do

      visit request_for_tender_build_path(sample_request_for_tender, :bill_of_quantities)

      click_link 'Save and continue', match: :first

      expect(page).to have_current_path(
                          request_for_tender_build_path(sample_request_for_tender,
                                                        :tender_documents)
                      )
    end

    scenario 'should go through bill of tender documents step' do

      visit request_for_tender_build_path(sample_request_for_tender, :tender_documents)

      click_link 'Save and continue', match: :first

      expect(page).to have_current_path(
                          request_for_tender_build_path(sample_request_for_tender,
                                                        :tender_instructions)
                      )
    end

    scenario 'should go through tender instructions step' do

      visit request_for_tender_build_path(sample_request_for_tender, :tender_instructions)

      click_button 'Save and continue', match: :first

      expect(page).to have_current_path(
                          request_for_tender_build_path(sample_request_for_tender,
                                                        :distribution)
                      )
    end



  end
end