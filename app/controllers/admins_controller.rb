# frozen_string_literal: true

class AdminsController < ApplicationController
  before_action :authenticate_admin!, except: :reverse_masquerade

  def review_request_for_tenders
    @submitted_tenders = RequestForTender.all.submitted.not_published
    @published_tenders = RequestForTender.all.published.deadline_not_passed
  end

  def review_request_for_tender
    if current_admin.eql?(nil)
      redirect_to rails_admin.dashboard_path
    else
      request_for_tender = RequestForTender.find(params[:id])
      bypass_sign_in(request_for_tender.quantity_surveyor)
      redirect_to request_for_tender_build_path(request_for_tender,
                                                :general_information)
    end
  end

  def monitor_request_for_tender
    if current_admin.eql?(nil)
      redirect_to rails_admin.dashboard_path
    else
      request_for_tender = RequestForTender.find(params[:id])
      bypass_sign_in(request_for_tender.quantity_surveyor)
      redirect_to request_for_tender_path(request_for_tender)
    end
  end

  def reverse_masquerade
    sign_out(QuantitySurveyor.find(params[:id]))
    redirect_to review_request_for_tenders_path
  end
end
