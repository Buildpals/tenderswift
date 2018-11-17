# frozen_string_literal: true

class Publishers::RegistrationsController < Devise::RegistrationsController
  #include Accessible
  #
  protect_from_forgery with: :exception, only: :create

  #skip_before_action :verify_authenticity_token, only: :create

  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super
    flash[:notice] = "A message with a confirmation link has been sent to " \
                     "your email address. Please open the link to set a " \
                     "password for your account."
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name phone_number company_name company_logo])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  def after_sign_up_path_for(_resource)
    if Rails.env.production?
      notifier = Slack::Notifier.new "https://hooks.slack.com/services/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" do
        defaults channel: "#sign-ups",
                 username: "TenderSwift Monitor"
      end
      notifier.ping "#{resource.full_name} <#{resource.email}> has signed up.",
                    icon_url: "https://res.cloudinary.com/tenderswift/image/upload/v1520934320/tenderswift-logo-square.png"
    end
    publishers_after_registration_path resource
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
