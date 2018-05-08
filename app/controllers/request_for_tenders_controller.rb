# frozen_string_literal: true

class RequestForTendersController < QuantitySurveyorsController
  before_action :set_request_for_tender, except: %i[create]

  before_action :set_policy

  def create
    @request_for_tender = current_quantity_surveyor.request_for_tenders.new
    authorize @request_for_tender
    @request_for_tender.setup_with_data
    redirect_to edit_tender_information_path @request_for_tender
  end

  def show
    authorize @request_for_tender
  end

  def compare_boq
    authorize @request_for_tender
    if Time.current > @request_for_tender.deadline
      render layout: 'compare_boq'
    else
      redirect_to quantity_surveyor_root_path,
                  notice: 'In accordance with tender fairness, you cannot ' \
                          'access the bids until the deadline is past.'
    end
  end

  def update
    authorize @request_for_tender
    respond_to do |format|
      if @request_for_tender.update(request_params)
        format.json { render :show, status: :ok, location: @request_for_tender }
        format.js
      else
        format.html { render :edit }
        format.js
        format.json do
          render json: @request_for_tender.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    authorize @request_for_tender
    @request_for_tender.destroy
    respond_to do |format|
      format.html do
        redirect_to request_for_tenders_url,
                    notice: 'Request was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  def set_policy
    RequestForTender.define_singleton_method(:policy_class) do
      RequestForTenderPolicy
    end
  end

  def set_request_for_tender
    @request_for_tender = RequestForTender.find(params[:id])
  end

  def request_params
    params.require(:request_for_tender)
          .permit(:deadline,
                  :selling_price,
                  :withdrawal_frequency,
                  :bank_name,
                  :branch_name,
                  :account_name,
                  :account_number,
                  :private,
                  tenders_attributes: %i[id
                                         email
                                         phone_number
                                         company_name
                                         _destroy])
  end
end
