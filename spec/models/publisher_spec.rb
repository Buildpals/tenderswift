# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Publisher, type: :model do
  let(:tender) { FactoryBot.create(:tender) }

  describe 'Associations' do
    it { should have_many(:request_for_tenders) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:email) }
    it 'should validate uniqueness of emails'
    it 'should validate format of email'
  end
end
