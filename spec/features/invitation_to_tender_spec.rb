# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Contractor can view an Invitation to Tender' do
  let!(:invitation_to_tender) { FactoryBot.create(:request_for_tender) }
  let!(:contractor) { FactoryBot.create(:contractor) }

  scenario 'before logging in' do
    visit purchase_tender_path(invitation_to_tender)

    should_have_invitation_to_tender_content
  end

  scenario 'after logging in' do
    login_as(contractor, scope: :contractor)

    visit purchase_tender_path(invitation_to_tender)

    should_have_invitation_to_tender_content
  end

  private

  def should_have_invitation_to_tender_content
    expect(page).to have_content invitation_to_tender.project_name
    expect(page).to have_content invitation_to_tender.project_owners_company_name
    expect(page).to have_content invitation_to_tender.contract_class
    expect(page).to have_content invitation_to_tender.project_location
    expect(page).to have_content invitation_to_tender.project_currency

    expect(page).to have_content invitation_to_tender.time_to_deadline
    expect(page).to have_content invitation_to_tender.project_deadline.to_formatted_s(:long)

    expect(page).to have_content invitation_to_tender.project_description

    invitation_to_tender.required_documents.each do |required_document|
      expect(page).to have_content required_document.title
    end

    expect(page).to have_content invitation_to_tender.tender_instructions
  end
end
