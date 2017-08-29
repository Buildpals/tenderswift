class Participant < ApplicationRecord

  include ActionView::Helpers::DateHelper

  has_secure_token :auth_token

  scope :bid_made, -> { where.not(bid_submission_time: nil) }
  scope :not_read, -> { where(request_read_time: nil) }
  scope :read, -> { where.not(request_read_time: nil) }
  scope :want_to_bid, -> { where(interested: true) }
  scope :not_participating, -> { where(interested: false) }

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

  def project_location
    "#{request_for_tender.city}, #{request_for_tender.country}"
  end

  def project_description
    request_for_tender.description
  end

  def time_left
    distance_of_time_in_words(Time.current, project_deadline)
  end
end
