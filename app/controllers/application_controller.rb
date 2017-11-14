class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(quantity_surveyor)
    request_for_tenders_path
  end

  def after_sign_up_path_for(quantity_surveyor)
    request_for_tenders_path
  end

  def after_inactive_sign_up_path_for(quantity_surveyor)
    new_quantity_surveyor_session_path
  end

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name phone_number company_name])
  end
end
