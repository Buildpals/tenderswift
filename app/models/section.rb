class Section < ApplicationRecord

    belongs_to :page

    has_many :items

    validates :name, presence: true
    
end
