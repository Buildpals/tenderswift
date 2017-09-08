json.extract! boq, :id, :name, :created_at, :updated_at
json.pages boq.pages do |page|
  json.id page.id
  json.name page.name
  json.items page.items.order(id: :asc) do |item|

    json.id item.id
    json.item_type item.item_type
    json.name item.name
    json.description item.description
    json.quantity item.quantity
    json.unit item.unit
    json.page_id item.page_id
    json.tag item.tag

  end
end
json.url boq_url(boq, format: :json)
