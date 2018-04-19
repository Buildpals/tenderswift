# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    if current_quantity_surveyor
      redirect_to quantity_surveyor_root_path
    elsif current_contractor
      redirect_to quantity_surveyor_root_path
    else
      redirect_to 'https://www.tenderswift.com'
    end
  end
end
