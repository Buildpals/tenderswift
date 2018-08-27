# frozen_string_literal: true

class Contractor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  mount_uploader :company_logo, CompanyLogoUploader

  has_many :tenders,
           dependent: :destroy,
           inverse_of: :contractor
  has_many :request_for_tenders, -> { distinct }, through: :tenders

  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

  EMAIL_MESSAGE = 'Please provide an correct email address with more than 5 characters'

  validates :full_name, presence: true, if: :active?
  validates :company_name, presence: true, if: :active?
  validates :company_logo, presence: true, if: :active?
  # validates :password, presence: true, if: :active?
  # validates :password_confirmation, presence: true, if: :active?

  validates :email, presence: { message: EMAIL_MESSAGE },
                    uniqueness: { message: EMAIL_MESSAGE,
                                  case_sensitive: false },
                    format: EMAIL_REGEX

  validates :phone_number, presence: true

  def name
    "#{company_name} (#{phone_number})"
  end

  def active?
    status == 'active'
  end
end
