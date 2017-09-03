class Participant < ApplicationRecord
  include ActionView::Helpers::DateHelper

  has_secure_token :auth_token

  enum status: [:not_read, :read, :not_participating,
                :participating, :bid_made]

  belongs_to :request_for_tender

  has_many :filled_items, dependent: :destroy
  accepts_nested_attributes_for :filled_items,
                                allow_destroy: true,
                                reject_if: :all_blank

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

  def project_documents
    request_for_tender.project_documents
  end

  def time_left
    distance_of_time_in_words(Time.current, project_deadline)
  end

  def boq
    request_for_tender.boq
  end

  def filled_item(item)
    filled_items.find_by(item_id: item.id) || FilledItem.new(item: item, participant: self)
  end

  def bid
    filled_items.inject(0) do |product, filled_item|
      product + (filled_item.item.quantity.to_f * filled_item.rate.to_f)
    end
  end
end
