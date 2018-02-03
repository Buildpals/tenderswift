class Boq < ApplicationRecord
  belongs_to :request_for_tender, inverse_of: :boq

  has_many :rates

  def name
      self.request_for_tender.project_name
  end

  def get_contract_sum participant
    contract_sum = 0
    rates = self.rates.where(participant_id: participant)
    rates.each { |r| contract_sum = r + r }
    return contract_sum
  end

end
