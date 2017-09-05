json.extract! request,
              :id,
              :project_name,
              :deadline,
              :country,
              :city,
              :description,
              :budget,
              :submitted,
              :created_at,
              :updated_at

json.participants request.participants do |participant|
  json.id participant.id
  json.email participant.email
  json.phone_number participant.phone_number
  json.bid participant.bid
end

json.url request_for_tender_url(request, format: :json)