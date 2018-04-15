# frozen_string_literal: true

class Tender < ApplicationRecord
  scope :purchased, -> { where(purchased: true) }
  scope :not_purchased, -> { where(purchased: false) }

  scope :submitted, -> { where(submitted: true) }
  scope :not_submitted, -> { where(submitted: false) }

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

  has_many :required_documents, through: :required_document_uploads

  has_many :rates, inverse_of: :tender

  has_one :tender_transaction, inverse_of: :tender, dependent: :destroy
  accepts_nested_attributes_for :tender_transaction,
                                allow_destroy: true,
                                reject_if: :all_blank

  delegate :project_name,
           :deadline,
           :city,
           :description,
           :country_code,
           :currency,
           :bill_of_quantities,
           :tender_instructions,
           :selling_price,
           :private,
           :contract_sum_address,
           :published,
           :published_time,
           to: :request_for_tender

  delegate :project_owners_name,
           :project_owners_company_name,
           :project_owners_company_logo,
           :project_owners_phone_number,
           :project_owners_email,
           to: :request_for_tender

  delegate :name,
           :company_name,
           :company_logo,
           :phone_number,
           :email,
           to: :contractor,
           prefix: :contractors

  def to_param
    "#{id}-#{project_name.parameterize}"
  end

  def required_document_upload_for(required_document)
    required_document_uploads.find_by(required_document_id: required_document.id) ||
      required_document_uploads.build(required_document_id: required_document.id)
  end

  def bid
    100_000
  end

  def save_rates(rate_updates)
    transaction do
      rate_updates.each do |rate_update|
        rate = rates.find_by(sheet: rate_update[:sheet],
                             row: rate_update[:row])
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

    Tender.new(
      request_for_tender: request_for_tender,
      contractor: contractor
    )
  end

  private

  def strip_qs_rates(workbook)
    workbook['Sheets'].each_value do |sheet|
      sheet.keys
           .select { |cell_address| (cell_address[0] == 'E') && (sheet[cell_address]['v'].is_a? Numeric) }
           .each { |cell_address| sheet[cell_address]['v'] = '' }
    end
    workbook
  end
end
