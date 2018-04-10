# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tender, type: :model do
  describe 'Associations' do
    it { should belong_to(:request_for_tender) }
    it { should belong_to(:contractor) }
  end
end
