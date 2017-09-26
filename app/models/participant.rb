class Participant < ApplicationRecord
  include ActionView::Helpers::DateHelper
  include  ActionView::Helpers::NumberHelper

  has_secure_token :auth_token

  enum status: {
      not_read: 0,
      read: 1,
      not_participating: 2,
      participating: 3,
      bid_made: 4
  }

  scope :not_read_list, -> {where(status: 0)}
  scope :read_list, -> {where(status: [1, 2, 3, 4, 5])}
  scope :not_participating_list, -> {where(status: 2)}
  scope :participating_list, -> {where(status: [3, 4])}
  scope :bid_list, -> {where(status: 4)}

  belongs_to :request_for_tender

  has_many :filled_items, dependent: :destroy
  accepts_nested_attributes_for :filled_items,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :items, through: :filled_items

  has_many :answer_boxes, inverse_of: :participant
  has_many :questions, through: :answer_boxes

  has_many :messages

  validates :email, presence: true

  validates :company_name, presence: true

  validates :phone_number, presence: true, uniqueness: true

  def to_param
    auth_token
  end

  def name
    if company_name.blank?
      email
    else
      company_name
    end
  end

  def project_owners_name
    request_for_tender.project_owners_name
  end

  def project_owners_phone_number
    request_for_tender.project_owners_phone_number
  end

  def project_owners_email
    request_for_tender.project_owners_email
  end

  def project_name
    request_for_tender.project_name
  end

  def project_deadline
    request_for_tender.deadline
  end

  def project_location
    request_for_tender.project_location
  end

  def project_description
    request_for_tender.description
  end

  def project_budget
    request_for_tender.budget
  end

  def contract_sum_currency
    request_for_tender.contract_sum_currency
  end

  def contract_sum
    request_for_tender.contract_sum
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

  def answer_box_for(question)
    answer_box = answer_boxes.find_by(question: question, participant: self) || answer_boxes.build(question: question, participant: self)
    # answer_box.answer_documents.build
    answer_box
  end

  def bid
    filled_items.where.not(amount: nil).inject(0) do |product, filled_item|
      product + filled_item.amount
    end
  end

  def bid_difference
    return ' - ' unless project_budget
    project_budget.to_d - bid
  end

  def bid_difference_as_percentage
    return ' - ' unless project_budget
    number_to_percentage 100 * (bid_difference / project_budget.to_d)
  end
end
