# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RequestForTender, type: :model do
  describe 'Associations' do
    it { should have_many(:tenders).dependent(:destroy) }
    it { should have_many(:contractors) }
  end
end
