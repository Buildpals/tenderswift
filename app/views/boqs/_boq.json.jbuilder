json.extract! boq, :id, :name, :created_at, :updated_at
json.pages boq.pages do |page|
  json.id page.id
  json.name page.name
  json.sections page.sections do |section|
    json.name section.name
    json.items section.items do |item|
      json.id item.id
      json.name item.name
      json.description item.description
      json.quantity item.quantity
      json.unit item.unit
      json.section_id item.section_id
    end
  end
end
json.url boq_url(boq, format: :json)
