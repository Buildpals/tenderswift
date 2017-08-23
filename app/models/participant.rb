class Participant < ApplicationRecord
    
    has_and_belongs_to_many :requests, join_table: :participants_requests

end
