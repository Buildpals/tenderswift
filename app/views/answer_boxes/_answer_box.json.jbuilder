json.extract! answer_box, :id, :question_id, :participant_id, :answer, :created_at, :updated_at
json.url answer_box_url(answer_box, format: :json)
