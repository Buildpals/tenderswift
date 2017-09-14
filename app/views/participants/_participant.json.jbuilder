json.extract! participant, :id, :email, :phone_number, :created_at, :updated_at

if participant.boq
  json.boq do
    json.id participant.boq.id
    json.name participant.boq.name
    json.pages participant.boq.pages do |page|
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
        json.filled_item participant.filled_item(item)
      end
    end
    json.url boq_url(participant.boq, format: :json)
  end
end

json.url participant_url(participant, format: :json)
