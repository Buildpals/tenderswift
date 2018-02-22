class Participant < ApplicationRecord
  include HasProject

  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::NumberHelper

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

  has_many :rates

  has_one :tender_transaction, dependent: :destroy
  accepts_nested_attributes_for :tender_transaction,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :required_document_uploads, dependent: :destroy
  accepts_nested_attributes_for :required_document_uploads,
                                allow_destroy: true,
                                reject_if: :all_blank

  validates :email, presence: true

  validates :company_name, presence: true

  validates :phone_number, presence: true


  validates :rating, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 5
  }

  def to_param
    auth_token
  end

  def filled_item(item)
    filled_items.find_by(item_id: item.id) || FilledItem.new(item: item, participant: self)
  end

  def answer_box_for(question)
    answer_box = answer_boxes.find_by(question: question, participant: self) || answer_boxes.build(question: question, participant: self)
    answer_box
  end

  def bid
    total_bid
  end

  def bid_difference
    return ' - ' unless project_budget
    project_budget.to_d - bid
  end

  def bid_difference_as_percentage
    return ' - ' unless project_budget
    number_to_percentage 100 * (bid_difference / project_budget.to_d)
  end

  def calculate_contract_sum
    contract_sum = 0.0
    rates.each do |rate|
      contract_sum += (rate.value.to_f * rate.quantity.to_f)
    end
    contract_sum
  end
end
