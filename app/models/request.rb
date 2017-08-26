class Request < ApplicationRecord

    has_one :excel, dependent: :destroy

    has_one :boq, dependent: :destroy, autosave: true

    has_and_belongs_to_many :participants, join_table: :participants_requests, dependent: :destroy

    validates :project_name, presence: true

    validates :deadline, presence: true

    validates :country, presence: true

    validates :city, presence: true
    
    validates :description, presence: true

    validates :budget, presence: true

    # Reads excel files into bill of quantities
    #
    # == Parameters:
    # execl::
    #   An instance of Excel class
    # 
    # request::
    #   An instance of Request class
    #
    # == Returns:
    # An instace of BOQ
    #

    def self.read_excel(excel, request)
      file = Creek::Book.new excel.document, remote: true
      worksheets = file.sheets
      boq = Boq.new(request.name)
        worksheets.each do |page|
          sheet = Page.new(name: page.name)
          section = Section.new
          puts "#############################################{page.name}"
          page.rows.each do |row|
              unless row.empty?
                  row.delete_if { |k, v| v.nil? }
                  if row.length.eql?(1)
                    section.name = row.values[0]
                    sheet.sections << section
                    puts "Section is #{row.values[0]}"
                  else
                    item = Item.new(name: row.values[0], description: row.values[1], quantity: row.values[2], rate: row.values[3])
                    section.items << item
                    puts "item is #{row.values[0]} name is #{row.values[1]}, quantity is #{row.values[2]} and unit is #{row.values[3]}"
                  end
              end
          end
          boq.pages << sheet
        end
        boq.request = request
        boq.save!
        boq
    end

end
