# frozen_string_literal: true

class BuildTenderPolicy
  attr_reader :contractor, :tender

  def initialize(contractor, tender)
    @contractor = contractor
    @tender = tender
  end

  def show?
    contractor_owns_the_tender? &&
      tender_is_purchased? &&
      tender_has_not_been_submitted
  end

  def update?
    contractor_owns_the_tender? &&
      tender_is_purchased? &&
      tender_has_not_been_submitted
  end

  def create?
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

  def tender_has_not_been_submitted
    !@tender.submitted?
    true
  end
end
