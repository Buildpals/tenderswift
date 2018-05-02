# frozen_string_literal: true

class TenderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  # PurchaseTenderController
  def portal?
    # code here
  end

  def purchase?
    # code here
  end

  def monitor_purchase?
    # code here
  end

  def complete_transaction?
    # code here
  end

  # BidsController
  def required_documents?
    user.id  == record.request_for_tender.quantity_surveyor.id
  end

  # def boq?
  #   user.id  == record.request_for_tender.quantity_surveyor.id
  # end

  def other_documents?
    user.id  == record.request_for_tender.quantity_surveyor.id
  end

  def disqualify?
    user.id  == record.request_for_tender.quantity_surveyor.id
  end

  def undo_disqualify?
    user.id  == record.request_for_tender.quantity_surveyor.id
  end

  def rate?
    user.id  == record.request_for_tender.quantity_surveyor.id
  end

  # TendersController
  def project_information?
    if record.request_for_tender.private?
      tender_purchased?
    else
      true
    end
  end

  def tender_documents?
    tender_purchased?
  end

  def boq?
    tender_purchased?
  end

  def contractors_documents?
    tender_purchased?
  end

  def results?
    tender_purchased?
  end

  def save_rates?
    tender_purchased?
  end

  def save_contractors_documents?
    tender_purchased?
  end

  def submit_tender?
    # code here
  end

  private

  def tender_purchased?
    true if user.id == record.contractor.id && record.purchased? == true
  end
end
