# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RequestForTender, type: :model do
  describe 'Associations' do
    it { should have_many(:tenders).dependent(:destroy) }
    it { should have_many(:contractors) }
  end

  context 'In the general information step' do
    before { allow(subject).to receive(:active_or_general_information?).and_return(true) }
    describe 'Validations' do
      it { should validate_presence_of(:project_name) }
      it { should validate_presence_of(:deadline) }
      #it { should validate_presence_of(:country_code) }
      #it { should validate_presence_of(:city) }
      it { should validate_presence_of(:description) }
      it 'should validate deadline cannot be in the past'
    end
  end
end
