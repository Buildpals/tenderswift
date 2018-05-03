# frozen_string_literal: true

class RequestForTenderPolicy
  attr_reader :quantity_surveyor, :request_for_tender

  def initialize(quantity_surveyor, request_for_tender)
    @quantity_surveyor = quantity_surveyor
    @request_for_tender = request_for_tender
  end

  # CreateTendersController
  def edit_tender_information?
    belongs_to_quantity_surveyor?
  end

  def update_tender_information?
    belongs_to_quantity_surveyor?
  end

  def edit_tender_boq?
    belongs_to_quantity_surveyor?
  end

  def update_tender_boq?
    belongs_to_quantity_surveyor?
  end

  def update_contract_sum_address?
    belongs_to_quantity_surveyor?
  end

  def edit_tender_documents?
    belongs_to_quantity_surveyor?
  end

  def update_tender_documents?
    belongs_to_quantity_surveyor?
  end

  def edit_tender_required_documents?
    belongs_to_quantity_surveyor?
  end

  def update_tender_required_documents?
    belongs_to_quantity_surveyor?
  end

  def edit_tender_payment_method?
    belongs_to_quantity_surveyor?
  end

  def update_tender_payment_method?
    belongs_to_quantity_surveyor?
  end

  def update_payment_details?
    belongs_to_quantity_surveyor?
  end

  def edit_tender_contractors?
    belongs_to_quantity_surveyor?
  end

  def update_tender_contractors?
    belongs_to_quantity_surveyor?
  end

  # RequestForTendersController
  def create?
    true
  end

  def show?
    belongs_to_quantity_surveyor?
  end

  def compare_boq?
    belongs_to_quantity_surveyor?
  end

  def update?
    belongs_to_quantity_surveyor?
  end

  def destroy?
    belongs_to_quantity_surveyor?
  end

  def scope
    Pundit.policy_scope!(quantity_surveyor, RequestForTender)
  end

  class Scope
    attr_reader :quantity_surveyor, :scope

    def initialize(quantity_surveyor, scope)
      @quantity_surveyor = quantity_surveyor
      @scope = scope
    end

    def resolve
      scope.where(quantity_surveyor_id: quantity_surveyor.id)
    end
  end

  private

  def belongs_to_quantity_surveyor?
    @quantity_surveyor.id == @request_for_tender.quantity_surveyor_id
  end
end
