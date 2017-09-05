class Excel < ApplicationRecord
  before_save :process_excel_file

  mount_uploader :document, DocumentUploader

  belongs_to :request_for_tender

  private

  def process_excel_file
    read_excel(document.file.path, request_for_tender)
  end

  def read_excel(file_path, request)
    file = Creek::Book.new file_path
    worksheets = file.sheets

    boq = Boq.create(name: request.project_name, request_for_tender: request)

    worksheets.each do |worksheet|
      page = Page.new(name: worksheet.name)
      add_worksheet_content_to_page(worksheet, page)
      boq.pages << page
    end

  end

  def add_worksheet_content_to_page(worksheet, page)
    list_of_sections = []
    # puts "#############################################{page.name}\n"
    worksheet.rows.each do |row|
      next if row.empty?
      if section?(row)
        add_section(list_of_sections, page, row)
      else
        add_item(list_of_sections, row)
      end
    end
  end

  def section?(row)
    row.delete_if { |_key, value| value.blank? }
    row.length.eql?(1)
  end

  def add_section(list_of_sections, page, row)
    section = Section.new(name: row.values[0])
    page.sections << section
    list_of_sections << section
    # puts "Section is #{row.values[0]}"
  end

  def add_item(list_of_sections, row)
    item = Item.new(name: row.values[0], description: row.values[1],
                    quantity: row.values[2], unit: row.values[3])
    last_section = list_of_sections.last
    last_section.items << item unless last_section.nil?
    # puts "item is #{row.values[0]} name is #{row.values[1]}, "
    # puts "quantity is #{row.values[2]} and unit is #{row.values[3]}"
  end
end
