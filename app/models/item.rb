class Item < ApplicationRecord
  enum item_type: {
    item: 0,
    header: 1
  }

  before_save :normalise_tag

  belongs_to :boq
  belongs_to :page

  has_many :filled_items, dependent: :destroy, autosave: true

  has_many :participants, through: :filled_items, dependent: :destroy, autosave: true

  def normalise_tag
    return if tag.nil?
    tag.strip!
    tag.downcase!
  end
end
