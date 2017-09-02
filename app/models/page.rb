class Page < ApplicationRecord

  belongs_to :boq

  has_many :sections, dependent: :destroy, autosave: true

  validates :name, presence: true

end
