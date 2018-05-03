# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  after_action :verify_authorized,
               except: :index,
               unless: :devise_controller?

  after_action :verify_policy_scoped,
               only: :index,
               unless: -> { return devise_controller? || welcome_controller? }

  protected

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || root_path)
  end

  def welcome_controller?
    controller_name == 'welcome'
  end
end
