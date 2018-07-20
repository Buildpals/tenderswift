# frozen_string_literal: true

class Tender < ApplicationRecord
  enum purchase_request_status: {
    pending: 0,
    success: 1,
    failed: 2
  }

  scope :purchased, -> { where.not(purchased_at: nil).order(purchased_at: :desc) }
  scope :not_purchased, -> { where(purchased_at: nil).order(purchased_at: :desc) }

  scope :submitted, -> {
                      where.not(submitted_at: nil).order(submitted_at: :desc)
                    }
  scope :not_submitted, -> {
                          where(submitted_at: nil).order(submitted_at: :desc)
                        }

  scope :read, -> { where(read: true) }
  scope :not_read, -> { where(read: false) }

  scope :disqualified, -> { where(disqualified: true) }
  scope :not_disqualified, -> { where(disqualified: false) }

  belongs_to :contractor, inverse_of: :tenders
  belongs_to :request_for_tender, inverse_of: :tenders

  has_many :required_document_uploads, inverse_of: :tender
  accepts_nested_attributes_for :required_document_uploads,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :other_document_uploads, inverse_of: :tender
  accepts_nested_attributes_for :other_document_uploads,
                                allow_destroy: true,
                                reject_if: :all_blank

  # has_many :required_documents, through: :required_document_uploads

  has_many :rates, inverse_of: :tender

  validates :contractor_id,
            uniqueness: {
              scope: :request_for_tender_id,
              message: 'should tender once per request for tender'
            }

  validate :check_required_documents, if: :submitting?

  validates :amount, presence: true, if: :purchasing?

  delegate :project_name, to: :request_for_tender
  delegate :deadline, to: :request_for_tender
  delegate :city, to: :request_for_tender
  delegate :description, to: :request_for_tender
  delegate :country_code, to: :request_for_tender
  delegate :currency, to: :request_for_tender
  delegate :tender_instructions, to: :request_for_tender
  delegate :selling_price, to: :request_for_tender
  delegate :private, to: :request_for_tender
  delegate :contract_sum_address, to: :request_for_tender
  delegate :published_at, to: :request_for_tender
  delegate :project_documents, to: :request_for_tender
  delegate :deadline_over?, to: :request_for_tender
  delegate :required_documents, to: :request_for_tender

  delegate :quantity_surveyor, to: :request_for_tender

  delegate :project_owners_name, to: :request_for_tender
  delegate :project_owners_company_name, to: :request_for_tender
  delegate :project_owners_company_logo, to: :request_for_tender
  delegate :project_owners_phone_number, to: :request_for_tender
  delegate :project_owners_email, to: :request_for_tender

  delegate :name, to: :contractor, prefix: :contractors
  delegate :company_name, to: :contractor, prefix: :contractors
  delegate :company_logo, to: :contractor, prefix: :contractors
  delegate :phone_number, to: :contractor, prefix: :contractors
  delegate :email, to: :contractor, prefix: :contractors

  def to_param
    "#{id}-#{project_name.parameterize}"
  end

  def purchased?
    !purchased_at.nil?
  end

  def submitted?
    !submitted_at.nil?
  end

  def reviewable?
    purchased? && submitted? && deadline_over?
  end

  def workbook
    workbook = request_for_tender.list_of_items_without_rates
    list_of_rates.each do |key, value|
      sheet_name = key.split('!')[0]
      row_col_ref = key.split('!')[1]
      workbook['Sheets'][sheet_name][row_col_ref]['v'] = value
    end
    workbook
  end

  def save_rates(rate_updates)
    transaction do
      rate_updates.each do |rate_update|
        rate = rates.find_by(sheet: rate_update[:sheet], row: rate_update[:row])
        if rate
          rate.update!(value: rate_update[:value])
        else
          rates.build(sheet: rate_update[:sheet],
                      row: rate_update[:row],
                      value: rate_update[:value])
        end
        save!
      end
      return true
    end
    false
  end

  def self.build_fake_tender(request_for_tender)
    contractor = Contractor.new(
      company_name: 'Example Company Ltd',
      phone_number: '+233240000000',
      email: 'example_tender@buildpals.com'
    )
    Tender.new(request_for_tender: request_for_tender, contractor: contractor)
  end

  def required_document_upload?(required_document)
    required_document_uploads.find_by(required_document: required_document)
  end

  private

  def purchasing?
    !purchased_at.nil?
  end

  def submitting?
    !submitted_at.nil?
  end

  def check_required_documents
    required_documents.each do |required_document|
      next if required_document_upload?(required_document)
      errors.add(required_document.title,
                 'is required but has not been uploaded')
    end
  end
end
