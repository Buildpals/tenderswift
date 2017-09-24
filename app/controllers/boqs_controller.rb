class BoqsController < ApplicationController
  before_action :set_boq, only: [:show, :edit, :update, :destroy]

  # GET /boqs
  # GET /boqs.json
  def index
    @boqs = Boq.all.includes(:pages, :items, :tags, :name)
  end

  # GET /boqs/1
  # GET /boqs/1.json
  def show
    gon.jbuilder
  end

  # GET /boqs/new
  def new
    @boq = Boq.new
  end

  # GET /boqs/1/edit
  def edit
  end

  # POST /boqs
  # POST /boqs.json
  def create
    @boq = Boq.new(boq_params)

    respond_to do |format|
      if @boq.save
        format.html { redirect_to @boq, notice: 'Boq was successfully created.' }
        format.json { render :show, status: :created, location: @boq }
      else
        format.html { render :new }
        format.json { render json: @boq.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boqs/1
  # PATCH/PUT /boqs/1.json
  def update
    respond_to do |format|
      if @boq.update(boq_params)
        format.html { redirect_to @boq, notice: 'Boq was successfully updated.' }
        format.json { render :show, status: :ok, location: @boq }
      else
        format.html { render :edit }
        format.json { render json: @boq.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boqs/1
  # DELETE /boqs/1.json
  def destroy
    @boq.destroy
    respond_to do |format|
      format.html { redirect_to boqs_url, notice: 'Boq was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_boq
      @boq = Boq.includes(:pages, :items, :tags, :name).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def boq_params
      params.require(:boq).permit(:name)
    end
end
