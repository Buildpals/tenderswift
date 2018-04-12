# frozen_string_literal: true

class QuantitySurveyorsController < ApplicationController
  before_action :set_quantity_surveyor, only: %i[edit update]
  before_action :authenticate_quantity_surveyor!

  # GET /quantity_surveyors/1/edit
  def edit; end

  # PATCH/PUT /quantity_surveyors/1
  # PATCH/PUT /quantity_surveyors/1.json
  def update
    respond_to do |format|
      if @quantity_surveyor.update(quantity_surveyor_params)
        format.html { redirect_to edit_quantity_surveyor_path(@quantity_surveyor), notice: 'Your account information was changed successfully.' }
        format.json { render :edit, status: :ok, location: @quantity_surveyor }
      else
        format.html { render :edit }
        format.json { render json: @quantity_surveyor.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def pundit_user
    current_quantity_surveyor
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_quantity_surveyor
    @quantity_surveyor = QuantitySurveyor.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
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
