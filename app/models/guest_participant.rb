class GuestParticipant
  include ActionView::Helpers::DateHelper
  include  ActionView::Helpers::NumberHelper

  def initialize(request_for_tender)
    @request_for_tender = request_for_tender
  end

  def id
    'guest'
  end

  def created_at
    request_for_tender.created_at
  end

  def updated_at
    request_for_tender.updated_at
  end

  def decline_url
    ''
  end

  def accept_url
    ''
  end

  def status
    'read'
  end

  def answer_boxes
    AnswerBox.none
  end


  def filled_items
    # FilledItem.none
  end

  def to_param
    "guest-#{request_for_tender.id}"
  end

  def request_for_tender
    @request_for_tender
  end

  def company_name
    'Example Company Ltd'
  end

  def email
    'example_participant@buildpals.com'
  end

  def first_name
    'John'
  end

  def last_name
    'Smith'
  end

  def phone_number
    '+233240000000'
  end

  def bid_submission_time
    nil
  end

  def request_read_time
    nil
  end

  def interested
    false
  end

  def interested_declaration_time
    nil
  end

  def declination_reason
    nil
  end

  def removed
    nil
  end

  def comment
    nil
  end

  def auth_token
    nil
  end

  def rating
    0
  end





  def not_read?
    true
  end

  def update(attributes)
    self
  end



  def name
    if company_name.blank?
      email
    else
      company_name
    end
  end

  def project_owners_name
    request_for_tender.project_owners_name
  end

  def project_owners_company_name
    request_for_tender.project_owners_company_name
  end

  def project_owners_phone_number
    request_for_tender.project_owners_phone_number
  end

  def project_owners_email
    request_for_tender.project_owners_email
  end

  def project_name
    request_for_tender.project_name
  end

  def project_deadline
    request_for_tender.deadline
  end

  def project_location
    request_for_tender.project_location
  end

  def project_description
    request_for_tender.description
  end

  def project_budget
    request_for_tender.budget
  end

  def contract_sum_currency
    request_for_tender.contract_sum_currency
  end

  def contract_sum
    request_for_tender.contract_sum
  end

  def project_documents
    request_for_tender.project_documents
  end

  def time_left
    distance_of_time_in_words(Time.current, project_deadline)
  end

  def boq
    request_for_tender.boq
  end

  def filled_item(item)
    filled_items.find_by(item_id: item.id) || FilledItem.new(item: item, participant: self)
  end

  def answer_box_for(question)
    answer_box = answer_boxes.find_by(question: question, participant: self) || answer_boxes.build(question: question, participant: self)
    # answer_box.answer_documents.build
    answer_box
  end

  def bid
    filled_items.where.not(amount: nil).inject(0) do |sum_of_amounts, filled_item|
      puts "#{sum_of_amounts} #{filled_item.item.quantity} #{filled_item.rate} #{filled_item.amount}"
      if filled_item.amount.nan?
        sum_of_amounts
      else
        sum_of_amounts + filled_item.amount.to_f
      end
    end
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