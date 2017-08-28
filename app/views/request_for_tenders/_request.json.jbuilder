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
              :updated_at,
              :participants

json.url request_for_tender_url(request, format: :json)
