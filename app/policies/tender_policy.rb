# frozen_string_literal: true

class TenderPolicy
  attr_reader :contractor, :tender

  def initialize(contractor, tender)
    @contractor = contractor
    @tender = tender
  end


  def project_information?
    contractor_owns_the_tender? && contractor_has_purchased_the_tender?
  end

  def tender_documents?
    contractor_owns_the_tender? && contractor_has_purchased_the_tender?
  end

  def boq?
    contractor_owns_the_tender? && contractor_has_purchased_the_tender?
  end

  def contractors_documents?
    contractor_owns_the_tender? && contractor_has_purchased_the_tender?
  end

  def results?
    contractor_owns_the_tender? &&
        contractor_has_purchased_the_tender? &&
        tender_has_been_submitted?
  end

  def save_rates?
    contractor_owns_the_tender? &&
        contractor_has_purchased_the_tender? &&
        tender_has_not_been_submitted
  end

  def save_contractors_documents?
    contractor_owns_the_tender? &&
        contractor_has_purchased_the_tender? &&
        tender_has_not_been_submitted
  end

  def submit_tender?
    contractor_owns_the_tender? &&
        contractor_has_purchased_the_tender? &&
        tender_has_not_been_submitted
  end

  private

  def contractor_owns_the_tender?
    @contractor == @tender.contractor
  end

  def contractor_has_purchased_the_tender?
    @tender.purchased?
  end

  def tender_has_been_submitted?
    @tender.submitted?
  end

  def tender_has_not_been_submitted
    !@tender.submitted?
  end
end
