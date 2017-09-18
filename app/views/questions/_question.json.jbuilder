json.extract! question, :id, :request_for_tender_id, :number, :title, :description, :question_type, :can_attach_documents, :mandatory, :choices, :created_at, :updated_at
json.url question_url(question, format: :json)
