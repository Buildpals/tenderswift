module ApplicationHelper
  def page_as_json(page, tender = nil)
    sheet_data = []
    page.sections.each do |section|
      create_section_header(section, sheet_data)
      if tender
        add_items_and_filled_items_to_section(section, sheet_data, tender)
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

  def add_items_and_filled_items_to_section(section, sheet_data, tender)
    section.items.each do |item|
      sheet_data.push(item: item.name,
                      description: item.description,
                      quantity: item.quantity,
                      unit: item.unit,
                      filled_item:  tender.filled_item(item))
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

  def pdf?(path)
    true if "pdf".include? File.extname(path)
  end


  require 'net/http'

  def working_url?(url_str)
    uri = URI.parse(URI.encode(url_str))
    if uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
      true
    else
      false
    end
  end

  def current_month
    month = Time.now.strftime('%m')
    month = month.to_i + 1
    get_month(month)
  end

  def get_month(index)
    months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    months[index]
  end

  def current_year
    Time.now.strftime('%Y')
  end
end
