class Item < ApplicationRecord
  belongs_to :boq
  belongs_to :page

  has_many :filled_items, dependent: :destroy, autosave: true

  has_many :participants, through: :filled_items, dependent: :destroy, autosave: true

  has_and_belongs_to_many :tags, join_table: :item_tags

  # validates :name, presence: true

  # validates :description, presence: true

  # validates :quantity, presence: true

  # validates :rate, presence: true

  # validates :amount, presence: true
end
