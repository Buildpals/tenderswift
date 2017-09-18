class Question < ApplicationRecord

  enum question_type: {
      text: 0,
      yes_no: 1,
      multiple_choice: 2,
      checkboxes: 3,
  }

  belongs_to :request_for_tender, inverse_of: :questions


end
