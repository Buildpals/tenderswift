class Page < ApplicationRecord

    belongs_to :boq

    has_many :sections

    validates :name, presence: true

end
