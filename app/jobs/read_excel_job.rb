class ReadExcelJob < ApplicationJob
  queue_as :default

  def perform(file_path, request_for_tender)
    RequestForTender.read_excel(file_path, request_for_tender)
  end
end
