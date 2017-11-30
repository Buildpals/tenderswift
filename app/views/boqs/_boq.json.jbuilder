json.extract! boq, :id, :name, :created_at, :updated_at
json.pages boq.pages do |page|
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
  end
end
json.url boq_url(boq, format: :json)
