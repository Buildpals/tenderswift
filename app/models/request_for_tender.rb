# frozen_string_literal: true

class RequestForTender < ApplicationRecord
  TENDERSWIFT_CUT = 0.12

  scope :published, -> { where(published: true) }
  scope :not_published, -> { where(published: false) }

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

  has_many :contractors, through: :tenders
  accepts_nested_attributes_for :contractors,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :tender_transactions,
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

  validates :project_name, presence: true
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

  def tender_figure
    # TODO: Fetch tender figure
    100_000
  end

  def number_of_tender_purchases
    tender_transactions.where(status: 'success').size
  end

  def total_receivable
    number_of_transactions = 0
    tender_transactions.each do |tender_transaction|
      number_of_transactions += 1 if tender_transaction.status.eql?('success')
    end
    total_of_transactions = number_of_transactions * selling_price
    total_of_transactions - (TENDERSWIFT_CUT * total_of_transactions)
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
end
