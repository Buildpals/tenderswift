# frozen_string_literal: true

class CreateTenderController < QuantitySurveyorsController
  before_action :set_request_for_tender

  before_action :set_policy

  # before_action :check_if_published

  def edit_tender_information
    authorize @request_for_tender
    @next_path = edit_tender_boq_path(@request_for_tender)
  end

  def update_tender_information
    authorize @request_for_tender
    if @request_for_tender.update(request_params)
      if params[:commit] == 'Next'
        redirect_to edit_tender_boq_path(@request_for_tender)
      else
        redirect_to edit_tender_information_path(@request_for_tender)
      end
    else
      render :edit_tender_information
    end
  end

  def edit_tender_boq
    authorize @request_for_tender
    @next_path = edit_tender_documents_path(@request_for_tender)
    if @request_for_tender.excel_file.nil?
      @request_for_tender.excel_file ||= ExcelFile.new
    end
  end

  def update_tender_boq
    authorize @request_for_tender
    if @request_for_tender.update(request_params)
      if params[:commit] == 'Back'
        redirect_to edit_tender_information_path(@request_for_tender)
      elsif params[:commit] == 'Next'
        redirect_to edit_tender_documents_path(@request_for_tender)
      else
        redirect_to edit_tender_boq_path(@request_for_tender)
      end
    else
      render :edit_tender_boq
    end
  end

  def update_contract_sum_address
    authorize @request_for_tender
    if @request_for_tender.update(request_params)
      render json: @request_for_tender, status: :ok,
             location: @request_for_tender
    else
      render json: @request_for_tender.errors, status: :unprocessable_entity
    end
  end

  def edit_tender_documents
    authorize @request_for_tender
    @next_path = edit_tender_required_documents

    if @request_for_tender.project_documents.empty?
      5.times { @request_for_tender.project_documents.build }
    end
  end

  def update_tender_documents
    authorize @request_for_tender
    if @request_for_tender.update(request_params)
      if params[:commit] == 'Back'
        redirect_to edit_tender_boq_path(@request_for_tender)
      elsif params[:commit] == 'Next'
        redirect_to edit_tender_required_documents_path(@request_for_tender)
      else
        redirect_to edit_tender_documents_path(@request_for_tender)
      end
    else
      render :edit_tender_documents
    end
  end

  def edit_tender_required_documents
    authorize @request_for_tender
    @next_path = edit_tender_payment_method_path(@request_for_tender)
  end

  def update_tender_required_documents
    authorize @request_for_tender
    if @request_for_tender.update(request_params)
      if params[:commit] == 'Back'
        redirect_to edit_tender_documents_path(@request_for_tender)
      elsif params[:commit] == 'Next'
        redirect_to edit_tender_payment_method_path(@request_for_tender)
      else
        redirect_to edit_tender_required_documents_path(@request_for_tender)
      end
    else
      render :edit_tender_required_documents
    end
  end

  def edit_tender_payment_method
    authorize @request_for_tender
    @next_path = edit_tender_contractors_path(@request_for_tender)
  end

  def update_tender_payment_method
    authorize @request_for_tender
    if @request_for_tender.update(request_params)
      if params[:commit] == 'Back'
        redirect_to edit_tender_required_documents_path(@request_for_tender)
      elsif params[:commit] == 'Next'
        redirect_to edit_tender_contractors_path(@request_for_tender)
      else
        redirect_to edit_tender_payment_method_path(@request_for_tender)
      end
    end
  end

  def update_payment_details
    authorize @request_for_tender
    # TODO: Consider moving this to the request_for_tenders controller
    # where it will be more apprioprate
    if @request_for_tender.update(request_params)
      redirect_to request_for_tender_path(@request_for_tender)
      flash[:notice] = 'Payment details has been changed successfully'
    else
      # TODO: Handle the errors for this action
      flash[:notice] = 'Payment details was not changed'
    end
  end

  def edit_tender_contractors
    authorize @request_for_tender
  end

  def update_tender_contractors
    authorize @request_for_tender
    @request_for_tender.update!(published_at: Time.current)

    if params[:commit] == 'Back'
      redirect_to edit_tender_payment_method_path(@request_for_tender)
    elsif params[:commit] == 'Publish'
      redirect_to request_for_tender_path(@request_for_tender)
    else
      redirect_to edit_tender_contractors_path
    end
  end

  private

  def set_policy
    RequestForTender.define_singleton_method(:policy_class) do
      CreateTenderPolicy
    end
  end

  def check_if_published
    if @request_for_tender.published?
      redirect_to quantity_surveyor_root_path, notice: 'A tender cannot
                                          be edited once it\'s sent out
                                          to contractors'
    end
  end

  def set_request_for_tender
    @request_for_tender = RequestForTender.find(params[:id])
  end

  def request_params
    params.require(:request_for_tender)
          .permit(:project_name,
                  :deadline,
                  :city,
                  :description,
                  :country_code,
                  :currency,
                  :bill_of_quantities,
                  :tender_instructions,
                  :selling_price,
                  :withdrawal_frequency,
                  :bank_name,
                  :branch_name,
                  :account_name,
                  :account_number,
                  :private,
                  excel_file_attributes: %i[id
                                            document
                                            _destroy],
                  project_documents_attributes: %i[id
                                                   document
                                                   _destroy],
                  contract_sum_address: %i[sheet cellAddress],
                  required_documents_attributes: %i[id
                                                    title
                                                    _destroy])
  end
end
