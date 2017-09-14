class Excel < ApplicationRecord
  before_save :process_excel_file

  mount_uploader :document, DocumentUploader

  belongs_to :request_for_tender

  validate :check_file_extension

  validates :document, presence: true

  private

  def check_file_extension
    return unless document
    accepted_formats = %w(.xlsx .xlsm)
    return if accepted_formats.include? File.extname(document.file.path)
    errors.add(:document, :invalid, message: 'The uploaded document should be an Excel(.xlsx or .xlsm) file.')
  end

  def process_excel_file
    read_excel(document.file.path, request_for_tender)
  end

  def read_excel(file_path, request_for_tender)
    file = Creek::Book.new file_path
    worksheets = file.sheets

    boq = Boq.create!(name: request_for_tender.project_name, request_for_tender: request_for_tender)

    worksheets.each do |worksheet|
      page = Page.create!(name: worksheet.name, boq: boq)
      add_worksheet_content_to_page(worksheet, page)
      boq.pages << page
    end
  end

  def add_worksheet_content_to_page(worksheet, page)
    worksheet.rows.each do |row|
      next if row.empty?
      if header?(row)
        add_header(row, page)
      else
        add_item(row, page)
      end
    end
  end

  def header?(row)
    row.delete_if {|_key, value| value.blank?}
    row.length.eql?(1)
  end

  def add_header(row, page)
    item = Item.create!(item_type: 'header', page: page, boq: page.boq, name: row.values[1],
                        description: row.values[0], quantity: row.values[2],
                        unit: row.values[3])
    item.priority = item.id
    item.save!
  end

  def add_item(row, page)
    item = Item.create!(item_type: 'item', page: page, boq: page.boq, name: row.values[0],
                        description: row.values[1], quantity: row.values[2],
                        unit: row.values[3])
    item.priority = item.id
    item.save!
  end
end
