class Participant < ApplicationRecord

    validates :email, presence: true

    validates :phone_number, presence: true

end
