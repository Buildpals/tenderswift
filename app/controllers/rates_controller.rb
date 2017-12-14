class RatesController < ApplicationController
  before_action :set_rate, only: [:show, :edit, :update, :destroy]

  # GET /rates
  # GET /rates.json
  def index
    @rate = Rate.new(rate_params)
    @rates = Rate.where(participant_id: @rate.participant_id).where(boq_id: @rate.boq_id).where(sheet_name: @rate.sheet_name)
    render json: @rates
  end

  # GET /rates/1
  # GET /rates/1.json
  def show
  end

  # GET /rates/new
  def new
    @rate = Rate.new
  end

  # GET /rates/1/edit
  def edit
  end

  # POST /rates
  # POST /rates.json
  def create
    @rate = Rate.new(rate_params) 
    old_rate = Rate.where(participant_id: @rate.participant_id).where(boq_id: @rate.boq_id).where(row_number: @rate.row_number).first
    puts old_rate.nil?
    puts @rate.inspect
    if old_rate.nil?
        respond_to do |format|
            if @rate.save
                format.json { render :show, status: :created, location: @rate }
            else
                format.json { render json: @rate.errors, status: :unprocessable_entity }
            end
        end
    else
        if old_rate.update(rate_params)
            render json: old_rate
        else
            render json: old_rate.errors.messages
        end
    end
  end

  # PATCH/PUT /rates/1
  # PATCH/PUT /rates/1.json
  def update
    respond_to do |format|
      if @rate.update(rate_params)
        format.html { redirect_to @rate, notice: 'Rate was successfully updated.' }
        format.json { render :show, status: :ok, location: @rate }
      else
        format.html { render :edit }
        format.json { render json: @rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rates/1
  # DELETE /rates/1.json
  def destroy
    @rate.destroy
    respond_to do |format|
      format.html { redirect_to rates_url, notice: 'Rate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rate
      @rate = Rate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rate_params
      params.require(:rate).permit(:boq_id, :sheet_name, :row_number, :value, :participant_id)
    end
end
