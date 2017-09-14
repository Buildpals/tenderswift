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
  json.name participant.name
  json.phone_number participant.phone_number
  json.bid participant.bid if action_name == 'show'
end

if request.boq
  json.boq do
    json.id request.boq.id
    json.name request.boq.name
    json.pages request.boq.pages do |page|
      json.id page.id
      json.name page.name
      json.items page.items.order(priority: :asc) do |item|
        json.id item.id
        json.item_type item.item_type
        json.name item.name
        json.description item.description
        json.quantity item.quantity.to_f if item.quantity
        json.unit item.unit
        json.page_id item.page_id
        json.boq_id item.boq_id
        json.priority item.priority
        json.tag item.tag
      end
    end
    json.url boq_url(request.boq, format: :json)
  end
end




json.url request_for_tender_url(request, format: :json)