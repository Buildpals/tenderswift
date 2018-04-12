class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  # after_action :verify_authorized, except: :index, unless: :devise_controller?
  # after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  # def after_sign_in_path_for(user)
  #   if user.class.eql?(QuantitySurveyor)
  #     quantity_surveyor_root_path
  #   elsif user.class.eql?(Contractor)
  #     # redirect to contractor dashboard
  #     contractor_root_path
  #   else
  #     rails_admin.dashboard_path
  #   end
  # end
  #


  protected

  def pundit_user
    current_quantity_surveyor
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
