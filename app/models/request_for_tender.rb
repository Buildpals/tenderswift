# frozen_string_literal: true

class RequestForTender < ApplicationRecord
  TENDERSWIFT_CUT = 0.10

  enum withdrawal_frequency: { 'Monthly' => 0,
                               'Every two weeks' => 1,
                               'Weekly' => 2 }

  enum access: {open_tendering: 0,
                closed_tendering: 1}

  serialize :contract_sum_address, Hash

  monetize :selling_price_subunit,
           as: :selling_price,
           with_model_currency: :tender_currency

  belongs_to :publisher, inverse_of: :request_for_tenders

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

  has_many :participants,
           dependent: :destroy,
           inverse_of: :request_for_tender
  accepts_nested_attributes_for :participants,
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
           to: :publisher,
           prefix: :project_owners

  scope :submitted, -> { where.not(submitted_at: nil).order(submitted_at: :desc) }
  scope :not_submitted, -> { where(submitted_at: nil).order(submitted_at: :desc) }

  scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }

  scope :not_published, -> { where(published_at: nil).order(published_at: :desc) }
  scope :deadline_not_passed, -> {
    where("deadline > '#{Time.current}'").order(id: :desc)
  }

  scope :submitted_tenders, -> { tenders.where(submitted: true) }

  validate :version_number_is_greater_or_same, if: :list_of_rates?

  def version_number_is_greater_or_same
    previous_version_number = version_number_was
    if version_number < previous_version_number
      errors.add(:version_number, 'is less than previous version number')
    end
  end

  validates :project_name, presence: true, if: :active?
  # validates :city, :country_code, presence: true, if: :not_sample?

  validate :check_deadline

  validates :project_name,
            :deadline,
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
    submitted_at.present?
  end

  def published?
    published_at.present?
  end

  def list_of_rates?
    list_of_rates.present?
  end

  def deadline_over?
    Time.current > deadline
  end

  def payment_gateway_charge
    selling_price * 0.035
  end

  def cloud_service_charge
    selling_price * 0.065
  end

  def amount_to_be_deducted
    selling_price + (RequestForTender::TENDERSWIFT_CUT * selling_price)
  end

  def number_of_tender_purchases
    tenders.where.not(purchased_at: nil).size
  end

  def total_receivable
    number_of_tender_purchases * selling_price
  end

  def setup_with_data(location)
    #byebug
    self.project_name = 'Untitled Project #' \
                        "#{publisher.request_for_tenders.count + 1}"
    self.country_code = location.country_code
    self.city = location.city
    self.deadline = Time.current + 1.month
    required_documents.build(title: 'Certificate of Incorporation')
    required_documents.build(title: 'Certificate of Commencement')
    required_documents.build(title: 'Financial statements (3 years )')
    save!
  end

  def setup_sample_request_for_tender(location)
    self.project_name = 'Sample Request For Tender'
    self.country_code = location.country_code
    self.city = location.city
    self.deadline = Time.current + 1.month
    self.description = 'The structure is a one-storey skeleton frames facility with solid sandcrete block walls as partitions. It covers an area of 478sqm'
    self.tender_currency = 'USD'
    self.selling_price_subunit = 10000
    self.bank_name = 'International Bank'
    self.account_name = 'Sample Construction Services'
    self.account_number = '123456789123456'
    self.withdrawal_frequency = 1
    self.tender_figure_address = 'Sheet4!F4'
    self.tender_instructions = 'Provide the required documents listed above'
    self.sample = true
    project_document = ProjectDocument.new(document: 'https://res.cloudinary.com/tenderswift/raw/upload/v1513201013/project_documents/contract_documents_qlxqzt.docx', original_file_name: 'Sample document')
    self.project_documents << project_document
    self.list_of_items = JSON.parse(File.read(Rails.root.join("app/uploaders/sample/sample_excel.json")))
    self.list_of_rates = JSON.parse(File.read(Rails.root.join("app/uploaders/sample/sample_rates.json")))
    required_documents.build(title: 'Certificate of Incorporation')
    required_documents.build(title: 'Financial statements (3 years )')
    save!
  end

  def workbook
    workbook = list_of_items_without_rates
    list_of_rates.each do |key, value|
      sheet_name = key.split('!')[0]
      row_col_ref = key.split('!')[1]
      workbook['Sheets'][sheet_name][row_col_ref]['v'] = value
    end
    workbook
  end

  def list_of_items_without_rates
    strip_qs_rates(list_of_items)
  end

  def get_list_of_rates(workbook)
    list_of_rates = {}
    workbook['SheetNames'].each do |sheetName|
      sheet = workbook['Sheets'][sheetName]
      sheet.keys
           .select { |cell_address| rate_cell?(cell_address, sheet) }
           .each do |cell_address|

        list_of_rates["#{sheetName}!#{cell_address}"] = sheet[cell_address]['v']
      end
    end
    list_of_rates
  end

  def tenders_with_mine
    value = tenders.submitted.as_json(only: %i[id list_of_rates],
                                      methods: [:contractors_company_name])
    my_tender = {
      id: 42,
      list_of_rates: list_of_rates,
      contractors_company_name: publisher.company_name
    }

    value.unshift(my_tender)
  end

  private

  def check_deadline
    return unless deadline

    if deadline < Date.today
      errors.add(:deadline, :invalid, message: 'Deadline cannot be in the past')
    end
  end

  def strip_qs_rates(workbook)
    workbook['Sheets'].each_value do |sheet|
      sheet.keys
           .select { |cell_address| rate_or_amount_cell?(cell_address, sheet) }
           .each do |cell_address|

        sheet[cell_address] = {
          'f' => sheet[cell_address]['f'],
          'v' => ''
        }

        sheet[cell_address]['c'] = 'allowEditing' if cell_address[0] == 'E'
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

  def not_sample?
    sample == false
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
