# frozen_string_literal: true

class Contractors::AfterSignupController < ContractorsController
  def edit
    authorize current_contractor
  end

  def update
    authorize current_contractor
    params[:contractor][:status] = 'active'
    if current_contractor.update(contractor_params)
      redirect_to contractor_root_path
    else
      render :edit
    end
  end

  def contractor_params
    params.require(:contractor).permit(
      :full_name,
      :email,
      :phone_number,
      :company_name,
      :company_logo,
      :status
    )
  end
end
