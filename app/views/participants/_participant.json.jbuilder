json.extract! participant, :id, :email, :phone_number, :created_at, :updated_at

json.boq do
  json.id participant.boq.id
  json.name participant.boq.name
  json.pages participant.boq.pages do |page|
    json.id page.id
    json.name page.name
    json.sections page.sections do |section|
      json.id section.id
      json.name section.name
      json.items section.items do |item|
        json.id item.id
        json.name item.name
        json.description item.description
        json.quantity item.quantity
        json.unit item.unit
        json.filled_item participant.filled_item(item)
      end
    end
  end
end

json.url participant_url(participant, format: :json)
