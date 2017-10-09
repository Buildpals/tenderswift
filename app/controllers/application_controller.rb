class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(user)
    if user.class.eql?(QuantitySurveyor)
      request_for_tenders_path
    else
      rails_admin.dashboard_path
    end
  end

  def after_sign_up_path_for(quantity_surveyor)
    request_for_tenders_path
  end

  def after_inactive_sign_up_path_for(quantity_surveyor)
    rails_admin.new_path
  end

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[phone_number company_name])
  end
end
