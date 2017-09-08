json.extract! boq, :id, :name, :created_at, :updated_at
json.pages boq.pages do |page|
  json.id page.id
  json.name page.name
  json.items page.items.order(id: :asc) do |item|
    json.partial! "items/item", item: item
  end
end
json.url boq_url(boq, format: :json)
