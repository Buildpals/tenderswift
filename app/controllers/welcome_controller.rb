# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    if current_publisher
      redirect_to publisher_root_path
    elsif current_contractor
      redirect_to publisher_root_path
    else
      redirect_to 'https://www.tenderswift.com'
    end
  end

  def query_request_for_tender
    render layout: false
  end

  def find_request_for_tender
    @search_result = RequestForTender.find(params[:reference_number])
    redirect_to purchase_tender_url(@search_result)
  rescue ActiveRecord::RecordNotFound
    render 'missing_request_for_tender_error'
  end
end
