class BroadcastMessage < ApplicationRecord
  belongs_to :chatroom
  
  has_many :participants

  has_one :quantity_surveyor
end
