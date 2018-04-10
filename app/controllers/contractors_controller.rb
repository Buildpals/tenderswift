# frozen_string_literal: true

class ContractorsController < ApplicationController

  before_action :authenticate_contractor!, only: [:dashboard]

  def dashboard; end

end
