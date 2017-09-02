class Section < ApplicationRecord

  belongs_to :page

  has_many :items, dependent: :destroy, autosave: true

  validates :name, presence: true

end
