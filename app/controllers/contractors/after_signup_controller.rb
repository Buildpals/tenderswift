# frozen_string_literal: true

class Contractors::AfterSignupController < ContractorsController
  def company_name; end

  def password; end

  def update_company_name
    authorize current_contractor
    if current_contractor.update(contractor_params)
      redirect_to contractors_after_signup_password_path
    else
      render :company_name
    end
  end

  def update_password
    authorize current_contractor
    params[:contractor][:status] = 'active'
    if current_contractor.update(contractor_params)
      redirect_to contractor_root_path
    else
      render :company_name
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
