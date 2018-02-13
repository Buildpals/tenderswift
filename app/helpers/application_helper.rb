module ApplicationHelper
  def page_as_json(page, participant = nil)
    sheet_data = []
    page.sections.each do |section|
      create_section_header(section, sheet_data)
      if participant
        add_items_and_filled_items_to_section(section, sheet_data, participant)
      else
        add_items_to_section(section, sheet_data)
      end
    end
    raw sheet_data.to_json
  end

  private

  def create_section_header(section, sheet_data)
    sheet_data.push(description: section.name)
  end

  def add_items_to_section(section, sheet_data)
    section.items.each do |item|
      sheet_data.push(item: item.name,
                      description: item.description,
                      quantity: item.quantity,
                      unit: item.unit)
    end
  end

  def add_items_and_filled_items_to_section(section, sheet_data, participant)
    section.items.each do |item|
      sheet_data.push(item: item.name,
                      description: item.description,
                      quantity: item.quantity,
                      unit: item.unit,
                      filled_item:  participant.filled_item(item))
    end
  end


  def is_admin_signin?
    request_path = request.fullpath.split('/')
    if request_path[1].eql?('admins')
      return true
    else
      return false
    end
  end

  def get_index_of_alphabet(alphabet)
    alphabets = ('A'...'z').to_a
    if alphabets.include?(alphabet)
        return alphabets.index(alphabet)
    end
  end


  require 'net/http'

  def working_url?(url_str)
    url = URI.parse(url_str)
    Net::HTTP.start(url.host, url.port) do |http|
      http.head(url.request_uri).code == '200'
    end
  rescue
    false
  end

end
