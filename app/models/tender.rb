# frozen_string_literal: true

class Tender < ApplicationRecord
  enum purchase_request_status: {
    pending: 0,
    success: 1,
    failed: 2
  }

  scope :purchased, -> { where.not(purchased_at: nil) }
  scope :not_purchased, -> { where(purchased_at: nil) }

  scope :submitted, -> { where.not(submitted_at: nil) }
  scope :not_submitted, -> { where(submitted_at: nil) }

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

  #has_many :required_documents, through: :required_document_uploads

  has_many :rates, inverse_of: :tender

  validates :contractor_id,
            uniqueness: {
              scope: :request_for_tender_id,
              message: 'should tender once per request for tender'
            }

  validate :check_required_documents

  delegate :project_name,         to: :request_for_tender
  delegate :deadline,             to: :request_for_tender
  delegate :city,                 to: :request_for_tender
  delegate :description,          to: :request_for_tender
  delegate :country_code,         to: :request_for_tender
  delegate :currency,             to: :request_for_tender
  delegate :tender_instructions,  to: :request_for_tender
  delegate :selling_price,        to: :request_for_tender
  delegate :private,              to: :request_for_tender
  delegate :contract_sum_address, to: :request_for_tender
  delegate :published_at,       to: :request_for_tender
  delegate :project_documents,    to: :request_for_tender
  delegate :deadline_over?,    to: :request_for_tender

  delegate :quantity_surveyor,    to: :request_for_tender

  delegate :project_owners_name,         to: :request_for_tender
  delegate :project_owners_company_name, to: :request_for_tender
  delegate :project_owners_company_logo, to: :request_for_tender
  delegate :project_owners_phone_number, to: :request_for_tender
  delegate :project_owners_email,        to: :request_for_tender

  delegate :name,         to: :contractor, prefix: :contractors
  delegate :company_name, to: :contractor, prefix: :contractors
  delegate :company_logo, to: :contractor, prefix: :contractors
  delegate :phone_number, to: :contractor, prefix: :contractors
  delegate :email,        to: :contractor, prefix: :contractors

  ERROR_TAG = 'Tender was not submitted - '

  def to_param
    "#{id}-#{project_name.parameterize}"
  end

  def build_required_document_uploads
    request_for_tender.required_documents.each do |required_document|
      if required_document_uploads.find_by(required_document: required_document)
        next
      end
      required_document_uploads.build(required_document: required_document)
    end
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

  def bid
    100_000
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

  def workbook
    workbook = JSON.parse(request_for_tender.bill_of_quantities)
    workbook = strip_qs_rates(workbook)
    rates.each do |rate|
      cell_address = "E#{rate.row}"
      workbook['Sheets'][rate.sheet][cell_address]['v'] = rate.value
    end
    workbook.to_json
  end

  def self.build_fake_tender(request_for_tender)
    contractor = Contractor.new(
      company_name: 'Example Company Ltd',
      phone_number: '+233240000000',
      email: 'example_tender@buildpals.com'
    )
    Tender.new(request_for_tender: request_for_tender, contractor: contractor)
  end

  private

  def strip_qs_rates(workbook)
    workbook['Sheets'].each_value do |sheet|
      sheet.keys
           .select { |cell_address| rate_cell?(cell_address, sheet) }
           .each { |cell_address| sheet[cell_address]['v'] = '' }
    end
    workbook
  end

  def rate_cell?(cell_address, sheet)
    cell_address[0] == 'E' && sheet[cell_address]['v'].is_a?(Numeric)
  end

  def check_required_documents
    return unless submitted_at.present?

    request_for_tender.required_documents.each do |required_document|
      if RequiredDocumentUpload.find_by(required_document_id:
                                            required_document.id).nil?
        errors.add(ERROR_TAG,
                   "#{required_document.title} has not been uploaded")
      end
    end
  end
end
