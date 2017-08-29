class RequestForTender < ApplicationRecord

  include ActionView::Helpers::DateHelper

  has_one :excel, dependent: :destroy

  has_one :boq, dependent: :destroy, autosave: true

  has_many :participants

  accepts_nested_attributes_for :participants,
                                allow_destroy: true,
                                reject_if: :all_blank

  validates :project_name, presence: true

  validates :deadline, presence: true

  def time_left_to_deadline
    if deadline.past?
      'ended'
    else
      time_left = distance_of_time_in_words(Time.current, deadline)
      "#{time_left} left"
    end
  end

  def self.read_excel(excel, request, remote = true)
    file = Creek::Book.new excel.document, remote: remote
    worksheets = file.sheets
    boq = Boq.new(request.name)
      worksheets.each do |page|
        sheet = Page.new(name: page.name)
        section = Section.new
        #puts "#############################################{page.name}"
        page.rows.each do |row|
            unless row.empty?
                row.delete_if { |k, v| v.nil? }
                if row.length.eql?(1)
                  section.name = row.values[0]
                  sheet.sections << section
                  #puts "Section is #{row.values[0]}"
                else
                  item = Item.new(name: row.values[0], description: row.values[1], quantity: row.values[2], unit: row.values[3])
                  section.items << item
                  #puts "item is #{row.values[0]} name is #{row.values[1]}, quantity is #{row.values[2]} and unit is #{row.values[3]}"
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
