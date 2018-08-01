# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Monitor request for tenders', type: :feature, js: true do
  let(:existing_admin) { FactoryBot.create(:admin) }

  let!(:submitted_request_for_tender) do
    FactoryBot.create(:request_for_tender, published_at: nil)
  end

  let!(:published_request_for_tender) do
    FactoryBot.create(:request_for_tender)
  end

  scenario 'should allow admin to monitor any publisher\'s' \
           ' request for tender' do
    login_as(existing_admin, scope: :admin)
    visit admin_root_path

    within :css, '#published-request-for-tenders' do
      click_link published_request_for_tender.project_name
    end

    click_link published_request_for_tender.project_owners_company_name
    click_link 'Stop impersonating'
    should_have_dashboard_content_for existing_admin
  end

  def should_have_dashboard_content_for(admin)
    expect(page).to have_current_path admin_root_path

    expect(page).to have_content 'Admin Dashboard'
    expect(page).to have_content admin.email
    expect(page).to have_link 'Rails Admin', href: rails_admin.dashboard_path
  end
end
