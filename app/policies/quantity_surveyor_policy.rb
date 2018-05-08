# frozen_string_literal: true

class QuantitySurveyorPolicy
  attr_reader :quantity_surveyor, :quantity_surveyor_profile

  def initialize(quantity_surveyor, quantity_surveyor_profile)
    @quantity_surveyor = quantity_surveyor
    @quantity_surveyor_profile = quantity_surveyor_profile
  end

  def dashboard?
    owns_quantity_surveyor_profile?
  end

  def edit?
    owns_quantity_surveyor_profile?
  end

  def update?
    owns_quantity_surveyor_profile?
  end

  private

  def owns_quantity_surveyor_profile?
    @quantity_surveyor == @quantity_surveyor_profile
  end
end
