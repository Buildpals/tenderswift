# frozen_string_literal: true

class RequestForTender < ApplicationRecord
  TENDERSWIFT_CUT = 0.12

  scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }
  scope :not_published, -> { where(published_at: nil).order(published_at: :desc) }

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
  accepts_nested_attributes_for :tenders,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :contractors, -> { distinct }, through: :tenders
  accepts_nested_attributes_for :contractors,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_one :excel_file,
          dependent: :destroy,
          inverse_of: :request_for_tender

  enum withdrawal_frequency: { 'Monthly' => 0,
                               'Every two weeks' => 1,
                               'Weekly' => 2 }

  delegate :name,
           :company_name,
           :company_logo,
           :phone_number,
           :email,
           to: :quantity_surveyor,
           prefix: :project_owners

  validates :project_name, presence: true, if: :active?
  # validate :check_deadline

  def to_param
    "#{id}-#{project_name.parameterize}"
  end

  def setup_with_data
    self.project_name = "Untitled Project ##{quantity_surveyor.request_for_tenders.count + 1}"
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

  def name
    "##{id} #{project_name}"
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

  def comparison_workbook
    workbook = JSON.parse(bill_of_quantities)
    tenders.each_with_index do |tender, index|
      tender.rates.each do |rate|
        cell_address = "#{to_s26(index + 1 + 6)}#{rate.row}"
        workbook['Sheets'][rate.sheet][cell_address] = { f: "=C#{rate.row}*#{rate.value}" }
      end
    end
    workbook.to_json
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

  private

  def check_deadline
    return unless deadline
    if deadline < Date.today
      errors.add(:deadline, :invalid, message: 'Deadline cannot be in the past')
    end
  end

  def to_s26(q)
    alpha26 = ('A'..'Z').to_a
    return '' if q < 1
    s = ''
    loop do
      q, r = (q - 1).divmod(26)
      s.prepend(alpha26[r])
      break if q.zero?
    end
    s
  end

  validates :project_name,
            :currency,
            :deadline,
            :country_code,
            :city,
            :description,
            presence: true,
            if: :active_or_general_information?

  # validates :bill_of_quantities, presence: true, if: :active_or_bill_of_quantities?
  # validates :tender_documents, presence: true, if: :active_or_tender_documents?
  # validates :tender_instructions, presence: true, if: :active_or_tender_instructions?
  validates :selling_price, presence: true, if: :active_or_distribution?

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
