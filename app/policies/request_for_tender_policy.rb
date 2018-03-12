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

  def edit_tender_participants?
    user.id == record.quantity_surveyor_id
  end

  def update_tender_participants?
    user.id == record.quantity_surveyor_id
  end


  # RequestForTendersController
  def index?
    user.id == record.quantity_surveyor_id
  end

  def show?
    user.id == record.quantity_surveyor_id
  end

  def portal?
    user.id == record.quantity_surveyor_id
  end

  def new?
    user.id == record.quantity_surveyor_id
  end

  def compare_boq?
    user.id == record.quantity_surveyor_id
  end

  def create?
    user.id == record.quantity_surveyor_id
  end

  def update?
    user.id == record.quantity_surveyor_id
  end

  def destroy?
    user.id == record.quantity_surveyor_id
  end
end