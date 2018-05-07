# frozen_string_literal: true

class PurchaseTenderPolicy
  attr_reader :contractor, :request_for_tender

  def initialize(contractor, request_for_tender)
    @contractor = contractor
    @request_for_tender = request_for_tender
  end

  def portal?
    request_for_tender_is_published?
  end

  def purchase?
    request_for_tender_is_published?
  end

  def monitor_purchase?
    request_for_tender_is_published?
  end

  def complete_transaction?
    request_for_tender_is_published?
  end

  private

  def request_for_tender_is_published?
    request_for_tender.published?
  end
end
