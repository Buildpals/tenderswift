class Item < ApplicationRecord
  enum item_type: {
    item: 0,
    header: 1
  }

  before_save :normalise_tag

  belongs_to :boq
  belongs_to :page

  has_many :filled_items, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :filled_items,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :participants, through: :filled_items, dependent: :destroy, autosave: true

  def normalise_tag
    return if tag.nil?
    tag.strip!
    tag.downcase!
  end
end
