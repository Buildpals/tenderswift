# frozen_string_literal: true

class PublishersController < ApplicationController
  before_action :authenticate_publisher!

  def dashboard
    authorize current_publisher
  end

  def edit
    authorize current_publisher
  end

  def update
    authorize current_publisher
    survey_response = true if current_publisher
                                   .time_for_first_request_for_tender.nil?
    respond_to do |format|
      if current_publisher.update(publisher_params)
        format.html do
          if survey_response == true
            redirect_to request_for_tender_build_path(current_publisher
                                                               .request_for_tenders.last, :general_information),
                        notice: 'Thank you. ' \
                                'A message with a confirmation link ' \
                                'has been sent to your email address. Please open the ' \
                                'link to set a password for your account.'
          else
            redirect_to edit_publisher_path(current_publisher),
                        notice: 'Your account information was changed' \
                      'successfully.'
          end
        end
        format.json do
          render :edit, status: :ok,
                        location: current_publisher
        end
      else
        format.html { render :edit }
        format.json do
          render json: current_publisher.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  protected

  def pundit_user
    current_publisher
  end

  private

  def publisher_params
    params.require(:publisher).permit(
      :full_name,
      :email,
      :phone_number,
      :company_name,
      :company_logo,
      :time_for_first_request_for_tender
    )
  end
end
