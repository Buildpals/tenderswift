# frozen_string_literal: true

class ContractorsController < ApplicationController
  before_action :authenticate_contractor!

  def dashboard; end
end
