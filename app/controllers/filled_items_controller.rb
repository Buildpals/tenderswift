class FilledItemsController < ApplicationController
  before_action :set_filled_item, only: [:show, :edit, :update, :destroy]

  # GET /filled_items
  # GET /filled_items.json
  def index
    @filled_items = FilledItem.all
  end

  # GET /filled_items/1
  # GET /filled_items/1.json
  def show
  end

  # GET /filled_items/new
  def new
    @filled_item = FilledItem.new
  end

  # GET /filled_items/1/edit
  def edit
  end

  # POST /filled_items
  # POST /filled_items.json
  def create
    @filled_item = FilledItem.new(filled_item_params)

    respond_to do |format|
      if @filled_item.save
        format.html { redirect_to @filled_item, notice: 'Filled item was successfully created.' }
        format.json { render :show, status: :created, location: @filled_item }
      else
        format.html { render :new }
        format.json { render json: @filled_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /filled_items/1
  # PATCH/PUT /filled_items/1.json
  def update
    respond_to do |format|
      if @filled_item.update(filled_item_params)
        format.html { redirect_to @filled_item, notice: 'Filled item was successfully updated.' }
        format.json { render :show, status: :ok, location: @filled_item }
      else
        format.html { render :edit }
        format.json { render json: @filled_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /filled_items/1
  # DELETE /filled_items/1.json
  def destroy
    @filled_item.destroy
    respond_to do |format|
      format.html { redirect_to filled_items_url, notice: 'Filled item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_filled_item
      @filled_item = FilledItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def filled_item_params
      params.require(:filled_item).permit(:amount, :rate, :participant_id, :item_id)
    end
end
