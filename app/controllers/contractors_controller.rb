# frozen_string_literal: true

class ContractorsController < ApplicationController
  before_action :authenticate_contractor!

  def dashboard
    authorize current_contractor

    unless current_contractor.status == 'active'
      redirect_to contractors_after_signup_path
    end

    @invitations_to_tender = []
    RequestForTender.published.deadline_not_passed.each do |rft|
      tender = rft.tenders.find_by(contractor_id: current_contractor.id)
      @invitations_to_tender.push rft if tender&.purchased_at.nil?
    end

    @purchased_tenders = current_contractor.tenders.purchased.not_submitted
    @submitted_tenders = current_contractor.tenders.purchased.submitted
  end

  def edit
    authorize current_contractor
  end

  def update
    authorize current_contractor
    respond_to do |format|
      if current_contractor.update(contractor_params)
        format.html do
          redirect_to edit_contractor_path(current_contractor),
                      notice: 'Your account information was changed  ' \
                              'successfully'
        end
        format.json { render :edit, status: :ok, location: current_contractor }
      else
        format.html { render :edit }
        format.json do
          render json: current_contractor.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  protected

  def pundit_user
    current_contractor
  end

  private

  def contractor_params
    params.require(:contractor).permit(
      :full_name,
      :email,
      :phone_number,
      :company_name,
      :company_logo
    )
  end
end
