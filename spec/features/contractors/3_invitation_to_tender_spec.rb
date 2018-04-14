# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Invitation to tender' do
  let!(:invitation_to_tender) { FactoryBot.create(:request_for_tender) }
  let!(:contractor) { FactoryBot.create(:contractor) }

  context 'when logged in' do
    scenario 'A contractor can view an invitation to tender' do
      visit purchase_tender_path(invitation_to_tender)

      contractor_should_see_invitation_to_tender_content
    end
  end

  context 'when logged out' do
    background do
      login_as(contractor, scope: :contractor)
    end

    scenario 'A contractor can view an invitation to tender' do
      visit purchase_tender_path(invitation_to_tender)

      contractor_should_see_invitation_to_tender_content
    end
  end

  private

  def contractor_should_see_invitation_to_tender_content
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
