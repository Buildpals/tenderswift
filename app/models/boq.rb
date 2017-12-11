class Boq < ApplicationRecord
  belongs_to :request_for_tender, inverse_of: :boq


  def name
      self.request_for_tender.project_name
  end
end
