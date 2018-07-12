# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  after_action :verify_authorized,
               only: :dashboard,
               unless: -> { devise_controller? || welcome_controller? }

  after_action :verify_policy_scoped,
               only: :index,
               unless: -> { devise_controller? || welcome_controller? }


  before_action :set_global_request_variable

  protected

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:alert] = t("#{policy_name}.#{exception.query}",
                      scope: 'pundit',
                      default: :default)

    redirect_to(request.referrer || root_path)
  end

  def welcome_controller?
    controller_name == 'welcome'
  end

  def set_global_request_variable
    $request = request
  end
end
