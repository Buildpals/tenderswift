# frozen_string_literal: true

class ContractorsController < ApplicationController
  before_action :authenticate_contractor!

  def dashboard; end

  protected

  def pundit_user
    current_contractor
  end
end
