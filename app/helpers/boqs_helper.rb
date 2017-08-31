module BoqsHelper
  def page_as_json(page)
    sheet_data = []
    page.sections.each do |section|
      create_section_header(section, sheet_data)
      add_items_to_section(section, sheet_data)
    end
    raw sheet_data.to_json
  end

  private

  def create_section_header(section, sheet_data)
    sheet_data.push(description: section.name)
  end

  def add_items_to_section(section, sheet_data)
    section.items.order(id: :asc).each do |item|
      sheet_data.push(item: item.name,
                      description: item.description,
                      quantity: item.quantity,
                      unit: item.unit,
                      rate: '',
                      amount: '')
    end
  end
end
