# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'View details of published request for tender', js: true do

  include RequestForTendersHelper
  let!(:publisher) {FactoryBot.create(:publisher)}
  let!(:request_for_tender) do
    FactoryBot.create(:request_for_tender,
                      :published, :submitted,
                      publisher: publisher)
  end

  scenario 'should show the contractor all the invitations to tender ' \
             'they have not purchased' do
    sign_in_publisher
    within :css, '#published-request-for-tender' do
      expect(page).to have_content request_for_tender.project_name
      expect(page).to have_content status request_for_tender
    end
  end

  def sign_in_publisher
    visit new_publisher_session_path
    fill_in 'Email address', with: publisher.email
    fill_in 'Password', with: publisher.password
    click_button 'Log in'
  end
end