class Participant < ApplicationRecord
  include HasProject

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

  has_many :rates

  validates :email, presence: true

  validates :company_name, presence: true

  validates :phone_number, presence: true

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
    sum = 0

    request_for_tender.boq.items.each do |item|
      filled_item = FilledItem.find_by(participant: self, item: item)

      if filled_item
        rate = filled_item.rate
      else
        rate = 0
      end

      if item.quantity.present?
        amount = rate * item.quantity
      else
        amount = rate
      end

      sum += amount
    end

    sum
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
