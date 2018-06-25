# frozen_string_literal: true

class ContractorsController < ApplicationController
  before_action :authenticate_contractor!

  def dashboard
    authorize current_contractor
    @request_for_tenders = RequestForTender
                           .published
                           .deadline_not_passed
                           .includes(:tenders)
                           .where.not(tenders: {
                                        contractor_id: current_contractor.id
                                      })

    unless current_contractor.status == 'active'
      redirect_to contractors_after_signup_path
    end
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
