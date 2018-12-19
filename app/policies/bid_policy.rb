# frozen_string_literal: true

class BidPolicy
  attr_reader :publisher, :tender

  def initialize(publisher, tender)
    @publisher = publisher
    @tender = tender
  end
  
  def required_documents?
    publisher_created_this_tenders_request_for_tender? &&
        tender.reviewable?
  end

  def boq?
    publisher_created_this_tenders_request_for_tender? &&
        tender.reviewable?
  end

  def other_documents?
    publisher_created_this_tenders_request_for_tender? &&
        tender.reviewable?
  end

  def disqualify?
    publisher_created_this_tenders_request_for_tender? &&
        tender.reviewable?
  end

  def undo_disqualify?
    publisher_created_this_tenders_request_for_tender? &&
        tender.reviewable?
  end

  def score?
    publisher_created_this_tenders_request_for_tender? &&
        tender.reviewable?
  end

  private

  def publisher_created_this_tenders_request_for_tender?
    publisher.id  == tender.request_for_tender.publisher.id
  end
end
