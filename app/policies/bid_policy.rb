# frozen_string_literal: true

class BidPolicy
  attr_reader :quantity_surveyor, :tender

  def initialize(quantity_surveyor, tender)
    @quantity_surveyor = quantity_surveyor
    @tender = tender
  end
  
  def required_documents?
    quantity_surveyor_created_this_tenders_request_for_tender?
  end

  def boq?
    quantity_surveyor_created_this_tenders_request_for_tender?
  end

  def other_documents?
    quantity_surveyor_created_this_tenders_request_for_tender?
  end

  def disqualify?
    quantity_surveyor_created_this_tenders_request_for_tender?
  end

  def undo_disqualify?
    quantity_surveyor_created_this_tenders_request_for_tender?
  end

  def rate?
    quantity_surveyor_created_this_tenders_request_for_tender?
  end

  private

  def quantity_surveyor_created_this_tenders_request_for_tender?
    # the request_for_tender that this tender belongs to, should have been
    # created by the logged in quantity surveyor
    quantity_surveyor.id  == tender.request_for_tender.quantity_surveyor.id &&
        tender.reviewable?
  end
end
