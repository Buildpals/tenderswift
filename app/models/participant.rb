class Participant < ApplicationRecord
    
    has_and_belongs_to_many :requests, join_table: :participants_requests

    validates :email, presence: true

    validates :phone_number, presence: true

end
