class AnswerBox < ApplicationRecord
  belongs_to :question, inverse_of: :answer_boxes
  belongs_to :participant, inverse_of: :answer_boxes

  has_many :answer_documents, dependent: :destroy
  accepts_nested_attributes_for :answer_documents,
                                allow_destroy: true,
                                reject_if: :all_blank
end
