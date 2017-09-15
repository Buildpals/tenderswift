class Chatroom < ApplicationRecord
  belongs_to :request_for_tender

  has_many :broadcast_messages
end
