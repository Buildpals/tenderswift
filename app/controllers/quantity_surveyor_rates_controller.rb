class QuantitySurveyorRatesController < ApplicationController
  before_action :set_quantity_surveyor_rate, only: [:show, :edit, :update, :destroy]

  # GET /quantity_surveyor_rates
  # GET /quantity_surveyor_rates.json
  def index
    @quantity_surveyor_rates = QuantitySurveyorRate.all
  end

  # GET /quantity_surveyor_rates/1
  # GET /quantity_surveyor_rates/1.json
  def show
  end

  # GET /quantity_surveyor_rates/new
  def new
    @quantity_surveyor_rate = QuantitySurveyorRate.new
  end

  # GET /quantity_surveyor_rates/1/edit
  def edit
  end

  # POST /quantity_surveyor_rates
  # POST /quantity_surveyor_rates.json
  def create
    parse_rate_data
  end

  # PATCH/PUT /quantity_surveyor_rates/1
  # PATCH/PUT /quantity_surveyor_rates/1.json
  def update
    respond_to do |format|
      if @quantity_surveyor_rate.update(quantity_surveyor_rate_params)
        format.html { redirect_to @quantity_surveyor_rate, notice: 'Quantity surveyor rate was successfully updated.' }
        format.json { render :show, status: :ok, location: @quantity_surveyor_rate }
      else
        format.html { render :edit }
        format.json { render json: @quantity_surveyor_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quantity_surveyor_rates/1
  # DELETE /quantity_surveyor_rates/1.json
  def destroy
    @quantity_surveyor_rate.destroy
    respond_to do |format|
      format.html { redirect_to quantity_surveyor_rates_url, notice: 'Quantity surveyor rate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quantity_surveyor_rate
      @quantity_surveyor_rate = QuantitySurveyorRate.find(params[:id])
    end

    #put this method into a job
    def parse_rate_data
        old_rates = QuantitySurveyorRate.where(boq_id: params[:quantity_surveyor_rates][:boq_id])
        unless old_rates.nil?
            old_rates.each{ |r| r.destroy! }
        end
        all_items = params[:quantity_surveyor_rates][:rate_data].split(',')
        all_items.each do |item|
            item_components = item.split('--')
            rate = item_components[0]
            sheet_name = item_components.last
            quantity_surveyor_rate = QuantitySurveyorRate.new(sheet_name: sheet_name, rate: rate, 
                                                                boq_id: params[:quantity_surveyor_rates][:boq_id], 
                                                                quantity_surveyor_id: params[:quantity_surveyor_rates][:quantity_surveyor_id])
            quantity_surveyor_rate.save!
        end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quantity_surveyor_rate_params
      params.require(:quantity_surveyor_rate).permit(:sheet_name, :rate, :quantity_surveyor_id, :boq_id, :rate_data)
    end
end
