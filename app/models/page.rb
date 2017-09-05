class Page < ApplicationRecord

  belongs_to :boq

  has_many :items, dependent: :destroy, autosave: true

  validates :name, presence: true

end
