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
    login_as(publisher, scope: :publisher)
    visit publisher_root_path
    within :css, '#published-request-for-tender' do
      expect(page).to have_content request_for_tender.project_name
      expect(page).to have_content status request_for_tender
    end
  end
end