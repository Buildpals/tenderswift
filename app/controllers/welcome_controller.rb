class WelcomeController < ApplicationController
  def index
    redirect_to request_for_tenders_path if quantity_surveyor_signed_in?
  end
end
