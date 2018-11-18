# frozen_string_literal: true

class Publishers::WelcomeController < PublishersController
  def edit
    authorize current_publisher
  end

  def update
    authorize current_publisher
    publisher = current_publisher

    if publisher.update(publisher_params)
      redirect_to publisher_root_path, notice: 'Ready to go! ' \
                                'A message with a confirmation link ' \
                                'has been sent to your email address. Please open the ' \
                                'link to set a password for your account.'
    else
      render :edit
    end
  end

  def publisher_params
    params.require(:publisher).permit(
        :company_name,
        :phone_number,
        :time_for_first_request_for_tender
    )
  end
end