# frozen_string_literal: true

class WelcomeController < ApplicationController
  before_action :authenticate_contractor!

  def index; end
end
