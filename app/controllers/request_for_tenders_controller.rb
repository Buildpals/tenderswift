class RequestForTendersController < ApplicationController
  before_action :set_request, only: %i[show
                                       compare_boq
                                       destroy
                                       portal]

  before_action :authenticate_quantity_surveyor!, except: %i[portal]

  DEFAULT_BROADCAST_CONTENT = 'If you have any questions you can reply me here'.freeze

  # GET /requests
  # GET /requests.json
  def index
    @requests = current_quantity_surveyor
                .request_for_tenders.order(updated_at: :desc)
  end

  # GET /requests/1
  # GET /requests/1.json
  def show; end

  # GET /projects/public/1
  def portal
    @participant = Participant.new
    @participant.build_tender_transaction
    render layout: 'portal'
  end

  # GET /requests/new
  def new
    @request = RequestForTender.create_new(current_quantity_surveyor)
    redirect_to edit_tender_information_path @request
  end

  def compare_boq
    if @request.deadline_over?
      render layout: 'compare_boq'
    else
      redirect_to request_for_tenders_path, notice: 'In accordance with tender
                                                  fairness, you cannot access
                                                  the bids until the deadline
                                                  is past.'
    end
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = RequestForTender.new(request_params)
    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.json { render :show, status: :ok, location: @request }
        format.js
      else
        format.html { render :edit }
        format.js
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to request_for_tenders_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = RequestForTender.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
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
                  participants_attributes: %i[id
                                              email
                                              phone_number
                                              company_name
                                              _destroy])
  end
end
