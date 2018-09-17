# frozen_string_literal: true

class RequestForTenderPolicy
  attr_reader :publisher, :request_for_tender

  def initialize(publisher, request_for_tender)
    @publisher = publisher
    @request_for_tender = request_for_tender
  end

  def create?
    true
  end

  def show?
    belongs_to_publisher?
  end

  def details?
    belongs_to_publisher?
  end

  def compare_boq?
    belongs_to_publisher?
  end

  def update?
    belongs_to_publisher?
  end

  def destroy?
    belongs_to_publisher?
  end

  def cash_out_now?
    belongs_to_publisher?
  end

  def scope
    Pundit.policy_scope!(publisher, RequestForTender)
  end

  class Scope
    attr_reader :publisher, :scope

    def initialize(publisher, scope)
      @publisher = publisher
      @scope = scope
    end

    def resolve
      scope.where(publisher_id: publisher.id)
    end
  end

  private

  def belongs_to_publisher?
    @publisher.id == @request_for_tender.publisher_id
  end
end
