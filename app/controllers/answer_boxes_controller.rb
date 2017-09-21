class AnswerBoxesController < ApplicationController
  before_action :set_answer_box, only: [:show, :edit, :update, :destroy]

  # GET /answer_boxes
  # GET /answer_boxes.json
  def index
    @answer_boxes = AnswerBox.all
  end

  # GET /answer_boxes/1
  # GET /answer_boxes/1.json
  def show
  end

  # GET /answer_boxes/new
  def new
    @answer_box = AnswerBox.new
  end

  # GET /answer_boxes/1/edit
  def edit
  end

  # POST /answer_boxes
  # POST /answer_boxes.json
  def create
    @answer_box = AnswerBox.new(answer_box_params)

    respond_to do |format|
      if @answer_box.save
        format.html {redirect_to participant_path(@answer_box.participant), notice: 'Answer box was successfully created.'}
        format.json {render :show, status: :created, location: @answer_box}
      else
        format.html {render :new}
        format.json {render json: @answer_box.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /answer_boxes/1
  # PATCH/PUT /answer_boxes/1.json
  def update
    respond_to do |format|
      if @answer_box.update(answer_box_params)
        format.html {redirect_to participant_path(@answer_box.participant), notice: 'Answer box was successfully updated.'}
        format.json {render :show, status: :ok, location: @answer_box}
      else
        format.html {render :edit}
        format.json {render json: @answer_box.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /answer_boxes/1
  # DELETE /answer_boxes/1.json
  def destroy
    @answer_box.destroy
    respond_to do |format|
      format.html {redirect_to answer_boxes_url, notice: 'Answer box was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_answer_box
    @answer_box = AnswerBox.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def answer_box_params
    params.require(:answer_box).permit(:question_id, :participant_id, :answer, answer_documents_attributes: [:id,
                                                                                                             :document,
                                                                                                             :_destroy])
  end
end
