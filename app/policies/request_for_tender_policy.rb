class RequestForTenderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(quantity_surveyor_id: user.id)
    end
  end

  # CreateTendersController
  def edit_tender_information?
    user.id == record.quantity_surveyor_id
  end

  def update_tender_information?
    user.id == record.quantity_surveyor_id
  end

  def edit_tender_boq?
    user.id == record.quantity_surveyor_id
  end

  def update_tender_boq?
    user.id == record.quantity_surveyor_id
  end

  def update_contract_sum_address?
    user.id == record.quantity_surveyor_id
  end

  def edit_tender_documents?
    user.id == record.quantity_surveyor_id
  end

  def update_tender_documents?
    user.id == record.quantity_surveyor_id
  end

  def edit_tender_required_documents?
    user.id == record.quantity_surveyor_id
  end

  def update_tender_required_documents?
    user.id == record.quantity_surveyor_id
  end

  def edit_tender_payment_method?
    user.id == record.quantity_surveyor_id
  end

  def update_tender_payment_method?
    user.id == record.quantity_surveyor_id
  end

  def update_payment_details?
    user.id == record.quantity_surveyor_id
  end

  def edit_tender_contractors?
    user.id == record.quantity_surveyor_id
  end

  def update_tender_contractors?
    user.id == record.quantity_surveyor_id
  end


  # RequestForTendersController
  def index?
    record.each do |r|
      return true if user.id == r.quantity_surveyor_id
    end
  end

  def show?
    quantity_surveyor?
  end

  def portal?
    true
  end

  def new?
    quantity_surveyor?
  end

  def compare_boq?
    quantity_surveyor?
  end

  def create?
    quantity_surveyor?
  end

  def update?
    quantity_surveyor?
  end

  def destroy?
    quantity_surveyor?
  end

  private

  def quantity_surveyor?
    user.id == record.quantity_surveyor_id
  end
end