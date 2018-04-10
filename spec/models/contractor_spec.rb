# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contractor, type: :model do
  describe 'Associations' do
    it { should have_many(:tenders).dependent(:destroy) }
    it { should have_many(:request_for_tenders) }
  end
end
