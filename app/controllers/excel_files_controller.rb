# frozen_string_literal: true

class ExcelFilesController < QuantitySurveyorsController
  before_action :set_request_for_tender
  before_action :set_excel_file, only: :destroy

  def create
    params[:excel_file][:original_file_name] =
      params[:excel_file][:document].original_filename

    workbook = JSON.parse params[:csf]
    list_of_rates = @request_for_tender.get_list_of_rates(workbook)
    @request_for_tender.list_of_items = workbook
    @request_for_tender.list_of_rates = list_of_rates

    @excel_file = @request_for_tender.build_excel_file(excel_file_params)

    if @excel_file.save && @request_for_tender.save
      @excel_file.reload
      render json: @excel_file, status: :created
    else
      render json: @excel_file.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @excel_file.destroy
    head :no_content
  end

  private

  def set_request_for_tender
    @request_for_tender = current_quantity_surveyor
                          .request_for_tenders
                          .find(params[:request_for_tender_id])
  end

  def set_excel_file
    @excel_file = @request_for_tender.excel_file
  end

  def excel_file_params
    params.require(:excel_file).permit(:document, :original_file_name)
  end
end
