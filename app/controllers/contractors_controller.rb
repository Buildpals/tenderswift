class ContractorsController < ApplicationController

  before_action :set_contractor, only: [:dashboard]

  def dashboard
  end

  private

  def set_contractor
    @contractor = Contractor.find(params[:id])
  end
end