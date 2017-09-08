class Tag < ApplicationRecord
  belongs_to :boq
  has_many :items
end
