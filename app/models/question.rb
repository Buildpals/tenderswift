class Question < ApplicationRecord

  serialize :choices, Array

  belongs_to :request_for_tender, inverse_of: :questions

  has_many :answer_boxes, inverse_of: :question, dependent: :destroy
  has_many :participants, through: :answer_boxes, dependent: :destroy
end
