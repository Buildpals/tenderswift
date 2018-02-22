class Participant < ApplicationRecord
  include HasProject

  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::NumberHelper

  has_secure_token :auth_token

  scope :purchased, -> { where(purchased: true) }
  scope :not_purchased, -> { where(purchased: false) }

  scope :submitted, -> { where(submitted: true) }
  scope :not_submitted, -> { where(submitted: false) }

  scope :read, -> { where(read: true) }
  scope :not_read, -> { where(read: false) }

  scope :disqualified, -> { where(disqualified: true) }
  scope :not_disqualified, -> { where(disqualified: false) }

  belongs_to :request_for_tender, inverse_of: :participants

  has_many :required_document_uploads, inverse_of: :participant
  accepts_nested_attributes_for :required_document_uploads,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :other_document_uploads, inverse_of: :participant
  accepts_nested_attributes_for :other_document_uploads,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :required_documents, through: :required_document_uploads

  has_many :rates, inverse_of: :participant

  has_one :tender_transaction, inverse_of: :participant, dependent: :destroy
  accepts_nested_attributes_for :tender_transaction,
                                allow_destroy: true,
                                reject_if: :all_blank

  validates :email, presence: true
  validates :company_name, presence: true
  validates :phone_number, presence: true

  def to_param
    auth_token
  end

  def filled_item(item)
    filled_items.find_by(item_id: item.id) || FilledItem.new(item: item, participant: self)
  end

  def required_document_upload_for(required_document)
    required_document_uploads.find_by(required_document_id: required_document.id) || required_document_uploads.build(required_document_id: required_document.id)
  end

  def bid
    100000
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
