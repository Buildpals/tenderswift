class Request < ApplicationRecord

    has_and_belongs_to_many :participants, join_table: :participants_requests

end
