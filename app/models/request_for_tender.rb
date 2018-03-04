class RequestForTender < ApplicationRecord
  include ActionView::Helpers::DateHelper

  BUILDPALS_CUT = 0.12

  scope :submitted, -> { where(submitted: true) }
  scope :not_submitted, -> { where(submitted: false) }

  monetize :selling_price_subunit,
           as: :selling_price,
           with_model_currency: :currency

  belongs_to :quantity_surveyor, inverse_of: :request_for_tenders

  has_many :project_documents, dependent: :destroy, inverse_of: :request_for_tender
  accepts_nested_attributes_for :project_documents,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :required_documents, dependent: :destroy, inverse_of: :request_for_tender
  accepts_nested_attributes_for :required_documents,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :participants, dependent: :destroy, inverse_of: :request_for_tender
  accepts_nested_attributes_for :participants,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :tender_transactions, dependent: :destroy, inverse_of: :request_for_tender

  enum withdrawal_frequency: { Monthly: 0, Every_Two_Weeks: 1, Weekly: 2 }

  validates :project_name, presence: true
  validate :check_deadline

  def check_deadline
    return unless deadline
    errors.add(:deadline, :invalid, message: 'Deadline cannot be in the past') if deadline < Date.today
  end

  def self.create_new(quantity_surveyor)
    new_request_for_tender = new
    new_request_for_tender.quantity_surveyor = quantity_surveyor
    new_request_for_tender.project_name = 'Untitled Project'
    new_request_for_tender.country_code = 'GH'
    new_request_for_tender.deadline = Time.current + 1.month
    new_request_for_tender.required_documents.build(title: 'Tax Clearance Certificate')
    new_request_for_tender.required_documents.build(title: 'SSNIT Clearance Certificate')
    new_request_for_tender.required_documents.build(title: 'Labour Certificate')
    new_request_for_tender.required_documents.build(title: 'Power of attorney')
    new_request_for_tender.required_documents.build(title: 'Certificate of Incorporation')
    new_request_for_tender.required_documents.build(title: 'Certificate of Commencement')
    new_request_for_tender.required_documents.build(title: 'Works and Housing certificate')
    new_request_for_tender.required_documents.build(title: 'Financial statements (3 years )')
    new_request_for_tender.required_documents.build(title: 'Bank Statement or evidence of Funding (letter of credit)')
    new_request_for_tender.save!
    new_request_for_tender.project_name = "Untitled Project ##{new_request_for_tender.id}"
    new_request_for_tender.save!
    new_request_for_tender
  end

  def currency_symbol
    currency == 'USD' ? '$' : 'GH₵'
  end

  def name
    "##{id} #{project_name}"
  end

  def country
    c = ISO3166::Country[country_code]
    c.translations[I18n.locale.to_s] || c.name
  end

  def project_owners_name
    quantity_surveyor.full_name
  end

  def project_owners_company_name
    quantity_surveyor.company_name
  end

  def project_owners_company_logo
    quantity_surveyor.company_logo
  end

  def project_owners_phone_number
    quantity_surveyor.phone_number
  end

  def project_owners_email
    quantity_surveyor.email
  end

  def project_deadline
    deadline
  end

  def project_description
    description
  end

  def project_location
    "#{city.present? ? city : 'N/A'}, #{country}"
  end

  def status
    if !submitted?
      'not submitted'
    else
      if deadline.past?
        'ended'
      else
        "#{time_left} left"
      end
    end
  end

  def contract_class
    # TODO: Return proper contract class
    'D1, K1'
  end

  def time_left
    distance_of_time_in_words_to_now(deadline)
  end

  def deadline_over?
    Time.current > deadline
  end

  def get_disqualified_contractors
    disqualified_participants = []
    participants.lazy.each do |participant|
      unless winner.auth_token.eql?(participant.auth_token)
        disqualified_participants.push(participant)
      end
    end
    disqualified_participants
  end

  def contract_sum
    # TODO: Fetch contract sum
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
    total_of_transactions - (BUILDPALS_CUT * total_of_transactions)
  end

  def comparison_workbook
    workbook = JSON.parse(bill_of_quantities)
    participants.each_with_index do |participant, index|
      participant.rates.each do |rate|
        cell_address = "#{to_s26(index + 1 + 6)}#{rate.row}"
        workbook['Sheets'][rate.sheet][cell_address] = { f: "=C#{rate.row}*#{rate.value}" }
      end
    end
    workbook.to_json
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
