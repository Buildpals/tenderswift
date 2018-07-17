# frozen_string_literal: true

class RequestForTender < ApplicationRecord
  TENDERSWIFT_CUT = 0.12

  enum withdrawal_frequency: { 'Monthly' => 0,
                               'Every two weeks' => 1,
                               'Weekly' => 2 }

  serialize :contract_sum_address, Hash

  monetize :selling_price_subunit,
           as: :selling_price,
           with_model_currency: :currency

  belongs_to :quantity_surveyor, inverse_of: :request_for_tenders

  has_many :project_documents,
           dependent: :destroy,
           inverse_of: :request_for_tender
  accepts_nested_attributes_for :project_documents,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :required_documents,
           dependent: :destroy,
           inverse_of: :request_for_tender
  accepts_nested_attributes_for :required_documents,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :tenders,
           dependent: :destroy,
           inverse_of: :request_for_tender

  has_many :contractors, -> { distinct }, through: :tenders

  has_one :excel_file,
          dependent: :destroy,
          inverse_of: :request_for_tender

  delegate :name,
           :company_name,
           :company_logo,
           :phone_number,
           :email,
           to: :quantity_surveyor,
           prefix: :project_owners

  scope :submitted, -> { where.not(submitted_at: nil).order(submitted_at: :desc) }
  scope :not_submitted, -> { where(submitted_at: nil).order(submitted_at: :desc) }

  scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }

  scope :not_published, -> { where(published_at: nil).order(published_at: :desc) }
  scope :deadline_not_passed, -> {
    where("deadline > '#{Time.current}'").order(id: :desc)
  }

  scope :submitted_tenders, -> { tenders.where(submitted: true) }

  validates :project_name, presence: true, if: :active?
  # validate :check_deadline

  validates :project_name,
            :currency,
            :deadline,
            :country_code,
            :city,
            :description,
            presence: true,
            if: :active_or_general_information?

  # validates :list_of_items, presence: true, if: :active_or_bill_of_quantities?
  # validates :tender_documents, presence: true, if: :active_or_tender_documents?
  # validates :tender_instructions, presence: true, if: :active_or_tender_instructions?
  validates :selling_price, presence: true, if: :active_or_distribution?

  def to_param
    "#{id}-#{project_name.parameterize}"
  end

  def name
    "##{id} #{project_name}"
  end

  def submitted?
    !submitted_at.nil?
  end

  def published?
    !published_at.nil?
  end

  def deadline_over?
    Time.current > deadline
  end

  def tender_figure
    # TODO: Fetch tender figure
    100_000
  end

  def number_of_tender_purchases
    tenders.where.not(purchased_at: nil).size
  end

  def total_receivable
    sum = 0
    tenders.each do |tender|
      sum += tender.amount if tender.purchased?
    end
    sum - (TENDERSWIFT_CUT * sum)
  end

  def tenders_including_mine
    tenders.as_json(include: :contractor).unshift(
      contractor: {
        company_name: project_owners_company_name,
        email: project_owners_email
      },
      list_of_rates: list_of_rates
    )
  end

  def list_of_items
    return nil if self[:list_of_items].nil?
    set_contractor_editable_fields(self[:list_of_items])
  end

  def list_of_items_without_rates
    strip_qs_rates(self[:list_of_items])
  end

  def setup_with_data
    self.project_name = "Untitled Project #" \
                        "#{quantity_surveyor.request_for_tenders.count + 1}"
    self.country_code = 'GH'
    self.deadline = Time.current + 1.month
    required_documents.build(title: 'Tax Clearance Certificate')
    required_documents.build(title: 'SSNIT Clearance Certificate')
    required_documents.build(title: 'Labour Certificate')
    required_documents.build(title: 'Power of attorney')
    required_documents.build(title: 'Certificate of Incorporation')
    required_documents.build(title: 'Certificate of Commencement')
    required_documents.build(title: 'Works and Housing certificate')
    required_documents.build(title: 'Financial statements (3 years )')
    required_documents.build(
      title: 'Bank Statement or evidence of Funding (letter of credit)'
    )
    save!
  end

  private

  def check_deadline
    return unless deadline
    if deadline < Date.today
      errors.add(:deadline, :invalid, message: 'Deadline cannot be in the past')
    end
  end

  def set_contractor_editable_fields(workbook)
    workbook['Sheets'].each_value do |sheet|
      sheet.keys
           .select { |cell_address| rate_or_amount_cell?(cell_address, sheet) }
           .each do |cell_address|
        # Preserve only the formula of that cell
        sheet[cell_address] = {
          'f' => sheet[cell_address]['f'],
          'v' => sheet[cell_address]['v'],
          'c' => 'allowEditing'
        }
      end
    end
    workbook
  end

  def strip_qs_rates(workbook)
    workbook['Sheets'].each_value do |sheet|
      sheet.keys
           .select { |cell_address| rate_or_amount_cell?(cell_address, sheet) }
           .each do |cell_address|
        # Preserve only the formula of that cell
        sheet[cell_address] = {
          'f' => sheet[cell_address]['f'],
          'v' => '',
          'c' => 'allowEditing'
        }
      end
    end
    workbook
  end

  def rate_or_amount_cell?(cell_address, sheet)
    rate_cell?(cell_address, sheet) || amount_cell?(cell_address, sheet)
  end

  def rate_cell?(cell_address, sheet)
    return false if cell_address[0] != 'E'
    return false if sheet[cell_address]['f']
    sheet[cell_address]['v'].is_a?(Numeric)
  end

  def amount_cell?(cell_address, sheet)
    return false if cell_address[0] != 'F'
    sheet[cell_address]['v'].is_a?(Numeric)
  end

  def active?
    status == 'active'
  end

  def active_or_general_information?
    status.include?(:general_information.to_s) || active?
  end

  def active_or_bill_of_quantities?
    status.include?(:bill_of_quantities.to_s) || active?
  end

  def active_or_tender_documents?
    status.include?(:tender_documents.to_s) || active?
  end

  def active_or_tender_instructions?
    status.include?(:tender_instructions.to_s) || active?
  end

  def active_or_distribution?
    status.include?(:distribution.to_s) || active?
  end
end
