# frozen_string_literal: true

class TenderPolicy
  attr_reader :contractor, :tender

  def initialize(contractor, tender)
    @contractor = contractor
    @tender = tender
  end


  def project_information?
    contractor_owns_the_tender? && tender_is_purchased?
  end

  def tender_documents?
    contractor_owns_the_tender? && tender_is_purchased?
  end

  def boq?
    contractor_owns_the_tender? && tender_is_purchased?
  end

  def contractors_documents?
    contractor_owns_the_tender? && tender_is_purchased?
  end

  def results?
    contractor_owns_the_tender? &&
        tender_is_purchased? &&
        tender_has_been_submitted?
  end

  def save_rates?
    contractor_owns_the_tender? &&
        tender_is_purchased? &&
        tender_has_not_been_submitted
  end

  def save_contractors_documents?
    contractor_owns_the_tender? &&
        tender_is_purchased? &&
        tender_has_not_been_submitted
  end

  def submit_tender?
    contractor_owns_the_tender? &&
        tender_is_purchased? &&
        tender_has_not_been_submitted
  end

  private

  def contractor_owns_the_tender?
    @contractor == @tender.contractor
  end

  def tender_is_purchased?
    @tender.purchased?
  end

  def tender_has_been_submitted?
    @tender.submitted?
  end

  def tender_has_not_been_submitted
    !@tender.submitted?
  end
end
