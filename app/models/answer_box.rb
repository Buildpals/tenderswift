class AnswerBox < ApplicationRecord
  belongs_to :question, inverse_of: :answer_boxes
  belongs_to :participant, inverse_of: :answer_boxes

  has_many :answer_documents, dependent: :destroy
  accepts_nested_attributes_for :answer_documents,
                                allow_destroy: true,
                                reject_if: :all_blank

  validates_associated :answer_documents
  validate :has_answer_documents

  def has_answer_documents
    if question.can_attach_documents
      if answer_documents.size < 1
        errors.add(:base, 'must attach at least one document in answering this this question')
      end
    end
  end
end
