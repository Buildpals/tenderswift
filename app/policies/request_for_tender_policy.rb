class RequestForTenderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(quantity_surveyor_id: user.id)
    end
  end

  def show?
    user.id == record.quantity_surveyor_id
  end
end
