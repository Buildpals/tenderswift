class Participant < ApplicationRecord

    has_many :items, through: :filled_items

    validates :email, presence: true

    validates :phone_number, presence: true

end
