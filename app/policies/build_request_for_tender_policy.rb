# frozen_string_literal: true

class BuildRequestForTenderPolicy
  attr_reader :quantity_surveyor, :request_for_tender

  def initialize(quantity_surveyor, request_for_tender)
    @quantity_surveyor = quantity_surveyor
    @request_for_tender = request_for_tender
  end

  def show?
    belongs_to_quantity_surveyor?
  end

  def update?
    belongs_to_quantity_surveyor? && request_for_tender_is_not_published?
  end

  def create?
    belongs_to_quantity_surveyor? && request_for_tender_is_not_published?
  end

  private

  def belongs_to_quantity_surveyor?
    @quantity_surveyor.id == @request_for_tender.quantity_surveyor_id
  end

  def request_for_tender_is_not_published?
    !request_for_tender.published?
  end
end
