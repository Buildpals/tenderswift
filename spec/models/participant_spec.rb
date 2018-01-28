require 'rails_helper'

RSpec.describe Participant, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  describe 'Participant instance methods' do

    it '#checks if contractors contract sum is calculated properly' do
      qs = QuantitySurveyor.new(company_name: 'Buildpals Inc',
                                email: 'kwaku@buildpals.com',
                                phone_number: '0509825831', password: '1234567890')
      qs.save!
      request = RequestForTender.new(project_name: 'testing',
                                     deadline: '2018-02-01 19:48:41', country_id: 1, submitted: true)
      request.quantity_surveyor = qs
      participant = Participant.new(email: 'trying@participant.com',
                                    company_name: 'Top Notch', phone_number: '0509825831')
      request.participants << participant
      participant.rates << Rate.new(value: 10, quantity: 12,
                                    participant_id: participant.id)
      participant.rates << Rate.new(value: 10, quantity: 12,
                                    participant_id: participant.id)
      participant.rates << Rate.new(value: 10, quantity: 12,
                                    participant_id: participant.id)
      participant.rates << Rate.new(value: 10, quantity: 12,
                                    participant_id: participant.id)
      participant.rates << Rate.new(value: 10, quantity: 12,
                                    participant_id: participant.id)
      participant.rates << Rate.new(value: 10, quantity: 12,
                                    participant_id: participant.id)
      participant.total_bid = participant.calculate_contract_sum
      expect(participant.total_bid).to eq(720.0)
    end

  end
end
