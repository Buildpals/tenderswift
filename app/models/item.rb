class Item < ApplicationRecord
  enum item_type: {
    item: 0,
    header: 1
  }

  belongs_to :boq
  belongs_to :page
  belongs_to :tag

  has_many :filled_items, dependent: :destroy, autosave: true

  has_many :participants, through: :filled_items, dependent: :destroy, autosave: true

  # validates :name, presence: true

  # validates :description, presence: true

  # validates :quantity, presence: true

  # validates :rate, presence: true

  # validates :amount, presence: true
end
