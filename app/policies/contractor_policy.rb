# frozen_string_literal: true

class ContractorPolicy
  attr_reader :contractor, :contractor_profile

  def initialize(contractor, contractor_profile)
    @contractor = contractor
    @contractor_profile = contractor_profile
  end

  def dashboard?
    owns_contractor_profile?
  end

  def edit?
    owns_contractor_profile?
  end

  def update?
    owns_contractor_profile?
  end

  private

  def owns_contractor_profile?
    @contractor = @contractor_profile
  end
end
