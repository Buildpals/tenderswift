class Participant < ApplicationRecord
  belongs_to :request_for_tender, inverse_of: :participants
end
