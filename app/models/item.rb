class Item < ApplicationRecord

  belongs_to :section

  has_many :filled_items

  has_many :participants, through: :filled_items

  # validates :name, presence: true
  # validates :description, presence: true
  # validates :quantity, presence: true
  # validates :unit, presence: true
end
