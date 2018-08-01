# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Invitation to tender' do
  include RequestForTendersHelper

  let(:invitation_to_tender) { FactoryBot.create(:request_for_tender) }
  let(:contractor) { FactoryBot.create(:contractor) }

  context 'when logged in' do
    scenario 'should show a contractor the general project information of an invitation to tender' do
      visit purchase_tender_path(invitation_to_tender)

      contractor_should_see_invitation_to_tender_content
    end
  end

  context 'when logged out' do
    background do
      login_as(contractor, scope: :contractor)
    end

    scenario 'should show a contractor the general project information of an invitation to tender' do
      visit purchase_tender_path(invitation_to_tender)

      contractor_should_see_invitation_to_tender_content
    end
  end

  private

  def contractor_should_see_invitation_to_tender_content
    user_sees_public_request_for_tender_information(invitation_to_tender)
  end
end
