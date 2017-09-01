class ReadExcelJob < ApplicationJob
  queue_as :default

  def perform(file_path, request_for_tender)
    unless request_for_tender.boq.nil?
      request_for_tender.boq.destroy
    end
    RequestForTender.read_excel(file_path, request_for_tender)
  end
end
