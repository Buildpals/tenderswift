class Participant < ApplicationRecord

    has_many :filled_items

    belongs_to :request_for_tender

    has_many :items, through: :filled_items

    validates :email, presence: true

    validates :phone_number, presence: true

end
