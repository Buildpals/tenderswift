class Question < ApplicationRecord

  serialize :choices, Array

  belongs_to :request_for_tender, inverse_of: :questions

  has_many :answers
  has_many :participants, through: :answers

end
