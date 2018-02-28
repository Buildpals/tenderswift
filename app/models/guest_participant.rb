class GuestParticipant
  include HasProject

  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::NumberHelper

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

  def update(_attributes)
    self
  end

  attr_reader :request_for_tender

  def company_name
    'Example Company Ltd'
  end

  def phone_number
    '+233240000000'
  end

  def email
    'example_participant@buildpals.com'
  end

  def auth_token
    nil
  end

  def purchased?
    false
  end

  def submitted
    false
  end

  def purchase_time; end

  def submitted_time; end

  def read?
    false
  end

  def rating
    0
  end

  def disqualified
    false
  end

  def notes; end

  def created_at; end

  def updated_at; end

  def created_at
    request_for_tender.created_at
  end

  def updated_at
    request_for_tender.updated_at
  end
end
