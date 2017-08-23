json.extract! request, :id, :project_name, :deadline, :country, :city, :description, :budget, :created_at, :updated_at
json.url request_url(request, format: :json)
