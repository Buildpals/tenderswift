class Participant < ApplicationRecord
  has_secure_token :auth_token

  has_many :filled_items

  belongs_to :request_for_tender

  has_many :items, through: :filled_items

  validates :email, presence: true

  validates :phone_number, presence: true

  def to_param
    auth_token
  end

  def project_name
    request_for_tender.project_name
  end

  def project_deadline
    request_for_tender.deadline
  end

  def project_description
    request_for_tender.description
  end
end
