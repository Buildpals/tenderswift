class GuestParticipant
  include HasProject

  include ActionView::Helpers::DateHelper
  include  ActionView::Helpers::NumberHelper

  def initialize(request_for_tender)
    @request_for_tender = request_for_tender
  end


  def id
    'guest'
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

  def status
    'read'
  end

  def created_at
    request_for_tender.created_at
  end

  def updated_at
    request_for_tender.updated_at
  end

  def answer_boxes
    AnswerBox.none
  end

  def filled_items
    # FilledItem.none
  end



  def update(attributes)
    self
  end




  def decline_url
    ''
  end

  def accept_url
    ''
  end


  def not_read?
    true
  end

  def filled_item(item)
    filled_items.find_by(item_id: item.id) || FilledItem.new(item: item, participant: self)
  end

  def answer_box_for(question)
    answer_box = answer_boxes.find_by(question: question, participant: self) || answer_boxes.build(question: question, participant: self)
    answer_box
  end

  def bid
    0
  end

  def bid_difference
    project_budget
  end

  def bid_difference_as_percentage
    number_to_percentage 0
  end
end