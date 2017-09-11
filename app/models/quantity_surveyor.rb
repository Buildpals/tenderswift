class QuantitySurveyor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable#, :confirmable

  has_many :request_for_tenders

  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
  
  EMAIL_MESSAGE = "Please provide an correct email address with more than 5 characters"

  validates :company_name, presence: true

  validates :email, presence: { message: EMAIL_MESSAGE }, uniqueness: { message: EMAIL_MESSAGE, case_sensitive: false }, length: { within: 5...100 }, format: EMAIL_REGEX

  validates :phone_number, presence: true, uniqueness: true
   

  def name
    "#{company_name} (#{email})"
  end
end
