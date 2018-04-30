# frozen_string_literal: true

class QuantitySurveyorsController < ApplicationController
  before_action :authenticate_quantity_surveyor!

  def dashboard
    authorize current_quantity_surveyor
  end

  def edit
    authorize current_quantity_surveyor
  end

  def update
    authorize current_quantity_surveyor
    respond_to do |format|
      if current_quantity_surveyor.update(quantity_surveyor_params)
        format.html do
          redirect_to edit_quantity_surveyor_path(current_quantity_surveyor),
                      notice: 'Your account information was changed' \
                      'successfully.'
        end
        format.json do
          render :edit, status: :ok,
                        location: current_quantity_surveyor
        end
      else
        format.html { render :edit }
        format.json do
          render json: current_quantity_surveyor.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  protected

  def pundit_user
    current_quantity_surveyor
  end

  private

  def quantity_surveyor_params
    params.require(:quantity_surveyor).permit(
      :full_name,
      :email,
      :phone_number,
      :company_name,
      :company_logo
    )
  end
end
