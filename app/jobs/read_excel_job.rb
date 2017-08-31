class ReadExcelJob < ApplicationJob
  queue_as :default

  def perform(file_path, request_for_tender)
    #boq = request_for_tender.boq
    #boq.pages.each do |p|
     # p.destroy!
      #p.sections.each do |s|
       # s.destroy!
      #end
    #end
    #boq.get_items.each do |i|
     # i.destroy!
    #end
    RequestForTender.read_excel(file_path, request_for_tender)
  end
end
