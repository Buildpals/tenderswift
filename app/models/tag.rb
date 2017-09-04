class Tag < ApplicationRecord
  belongs_to :boq

  has_and_belongs_to_many :items, join_table: :item_tags
end
