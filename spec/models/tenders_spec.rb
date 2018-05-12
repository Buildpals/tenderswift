# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tender, type: :model do
  describe 'Associations' do
    it { should belong_to(:request_for_tender) }
    it { should belong_to(:contractor) }
  end

  describe 'Validations' do
    it 'should validate uniqueness of request_for_tender_id with contractor_id'

    it 'raises error if (request_for_tender_id, contractor_id) pair is not unique, even if validations pass' do
      contractor = FactoryBot.create(:contractor)
      request_for_tender = FactoryBot.create(:request_for_tender)
      Tender.create(request_for_tender: request_for_tender,
                    contractor: contractor)
      tender2 = Tender.new(request_for_tender: request_for_tender,
                           contractor: contractor)
      expect do
        tender2.save(validate: false)
      end .to raise_error(ActiveRecord::RecordNotUnique)
    end

    it 'should validate presence of amount field if purchased_at is set' do
      tender = FactoryBot.create(:tender)
      expect { tender.update!(purchased_at: Time.current) }
          .to raise_error(ActiveRecord::RecordInvalid,
                          'Validation failed: Amount can\'t be blank')
    end
  end
end
