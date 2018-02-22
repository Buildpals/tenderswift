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

  def to_model
    Participant.new
  end

  def update(attributes)
    self
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

  def interested_declaration_time
    nil
  end

  def declination_reason
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
    'guest'
  end

  def not_read?
    true
  end

  def read?
    false
  end

  def not_participating?
    false
  end

  def participating?
    false
  end

  def bid_made?
    false
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

  def items
    FilledItem.none
  end


  def filled_items
    FilledItem.none
  end

  def questions
    Question.none
  end

  def messages
    Message.none
  end


  def filled_item(item)
    FilledItem.new
  end

  def answer_box_for(question)
    AnswerBox.new
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