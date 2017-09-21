json.extract! message, :id, :content, :broadcast_message_id, :participant_id, :created_at, :updated_at
json.url message_url(message, format: :json)
