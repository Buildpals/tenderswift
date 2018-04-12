# frozen_string_literal: true

module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_user
  end

  protected

  def check_user
    if current_contractor
      flash.clear
      # if you have rails_admin. You can redirect anywhere really
      redirect_to(contractor_root_path) && return
    elsif current_quantity_surveyor
      flash.clear
      # The authenticated root path can be defined in your routes.rb in: devise_scope :user do...
      redirect_to(quantity_surveyor_root_path) && return
    end
  end
end
