# frozen_string_literal: true

class Publisher < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable

  mount_uploader :company_logo, CompanyLogoUploader

  has_many :request_for_tenders,
           dependent: :destroy,
           inverse_of: :publisher

  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

  EMAIL_MESSAGE = 'Please provide an correct email address with more than 5 characters'

  #validates :company_name, presence: true

  validates :email, presence: { message: EMAIL_MESSAGE },
                    uniqueness: { message: EMAIL_MESSAGE,
                                  case_sensitive: false },
                    format: EMAIL_REGEX

  #validates :phone_number, presence: true

  def name
    "#{company_name} (#{email})"
  end

  protected

  def password_required?
    confirmed? ? super : false
  end

  def confirmation_required?
    false
  end
end
