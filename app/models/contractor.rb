# frozen_string_literal: true

class Contractor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tenders, dependent: :destroy, inverse_of: :contractor
  has_many :request_for_tenders, through: :tenders

  def self.create_and_purchase(request_for_tender,
                               signup_params,
                               payment_params)
    contractor = Contractor.new(signup_params)
    contractor.build_tender(request_for_tender, payment_params)
  end

  def self.validate_and_purchase(request_for_tender,
                                 login_params,
                                 payment_params)
    contractor = Contractor.find_by(email: login_params[:email])
    return nil unless contractor.valid_password?(login_params[:password])

    contractor.build_tender(request_for_tender, payment_params)
  end

  def build_tender(request_for_tender, payment_params)
    tenders.build(
      request_for_tender: request_for_tender,
      amount: request_for_tender.selling_price,
      customer_number: payment_params[:customer_number],
      network_code: payment_params[:network_code],
      vodafone_voucher_code: payment_params[:vodafone_voucher_code],
      transaction_id: 'DEVELOPMENT_TRANSACTION',
      status: 'success',
      purchased: true,
      purchase_time: Time.current
    )
    self
  end
end
