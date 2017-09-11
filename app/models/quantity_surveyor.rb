class QuantitySurveyor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :request_for_tenders

  validates :company_name, presence: true

  def name
    "#{company_name} (#{email})"
  end
end
