# frozen_string_literal: true

class BuildRequestForTenderPolicy
  attr_reader :publisher, :request_for_tender

  def initialize(publisher, request_for_tender)
    @publisher = publisher
    @request_for_tender = request_for_tender
  end

  def show?
    belongs_to_publisher? && request_for_tender_is_not_published?
  end

  def update?
    belongs_to_publisher? && request_for_tender_is_not_published?
  end

  def create?
    belongs_to_publisher? && request_for_tender_is_not_published?
  end

  private

  def belongs_to_publisher?
    @publisher.id == @request_for_tender.publisher_id
  end

  def request_for_tender_is_not_published?
    !@request_for_tender.published?
  end
end
