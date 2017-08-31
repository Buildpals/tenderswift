class RequestForTender < ApplicationRecord
  include ActionView::Helpers::DateHelper

  scope :submitted, -> {where(submitted: true)}
  scope :not_submitted, -> {where(submitted: false)}

  has_one :excel, dependent: :destroy

  has_one :boq, dependent: :destroy, autosave: true

  has_many :participants, dependent: :destroy
  accepts_nested_attributes_for :participants,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :project_documents, dependent: :destroy
  accepts_nested_attributes_for :project_documents,
                                allow_destroy: true,
                                reject_if: :all_blank

  validates :project_name, presence: true

  validates :deadline, presence: true

  def status
    if !submitted?
      'not submitted'
    else
      if deadline.past?
        'ended'
      else
        "#{time_left} left"
      end
    end
  end

  def time_left
    distance_of_time_in_words(Time.current, deadline)
  end

  def self.read_excel(file_path, request)
    file = Creek::Book.new file_path
    worksheets = file.sheets
    boq = Boq.new(name: request.project_name)
      worksheets.each do |page|
        page = Page.new(name: page.name)
        #puts "#############################################{page.name}"
        page.rows.each do |row|
            unless row.empty?
                row.delete_if { |key, value| value.nil? }
                if row.length.eql?(1)
                  section = Section.new                
                  section.name = row.values[0]
                  page.sections << section
                  #puts "Section is #{row.values[0]}"
                else
                  item = Item.new(name: row.values[0], description: row.values[1], quantity: row.values[2], unit: row.values[3])
                  section.items << item
                  #puts "item is #{row.values[0]} name is #{row.values[1]}, quantity is #{row.values[2]} and unit is #{row.values[3]}"
                end
            end
        end
        boq.pages << page
      end
      boq.request_for_tender = request
      boq.save!
      boq
  end
end
