class Section < ApplicationRecord

  belongs_to :page

  has_many :items, dependent: :destroy, autosave: true

  validates :name, presence: true

  def total(participant)
    total = 0
    items.each do |item|
      filled_item = item.filled_items.find_by(participant: participant)
      total += filled_item.amount
    end
    total
  end
end
