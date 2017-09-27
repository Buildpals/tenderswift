class BroadcastMessagesController < ApplicationController

  before_action :set_broadcast_message, only: [:show, :edit, :update, :destroy]

  skip_before_action :verify_authenticity_token, only: [ :create ]

  # GET /broadcast_messages
  # GET /broadcast_messages.json
  def index
    @broadcast_messages = BroadcastMessage.all
  end

  # GET /broadcast_messages/1
  # GET /broadcast_messages/1.json
  def show
  end

  # GET /broadcast_messages/new
  def new
    @broadcast_message = BroadcastMessage.new
  end

  # GET /broadcast_messages/1/edit
  def edit
  end

  # POST /broadcast_messages
  # POST /broadcast_messages.json
  def create
    @broadcast_message = BroadcastMessage.new(broadcast_message_params)

    respond_to do |format|
      if @broadcast_message.save
        @broadcast_message.chatroom.request_for_tender.participants.each do |participant|
          BroadcastMailer.deliver_broadcast_email(participant, @broadcast_message).deliver_later
        end
        #BroadcastEmailJob.perform_later(@broadcast_message)
        #format.html { redirect_to @broadcast_message, notice: 'Broadcast message was successfully created.' }
        format.json { render :show, status: :created, location: @broadcast_message }
      else
        format.html { render :new }
        format.json { render json: @broadcast_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /broadcast_messages/1
  # PATCH/PUT /broadcast_messages/1.json
  def update
    respond_to do |format|
      if @broadcast_message.update(broadcast_message_params)
        format.html { redirect_to @broadcast_message, notice: 'Broadcast message was successfully updated.' }
        format.json { render :show, status: :ok, location: @broadcast_message }
      else
        format.html { render :edit }
        format.json { render json: @broadcast_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /broadcast_messages/1
  # DELETE /broadcast_messages/1.json
  def destroy
    @broadcast_message.destroy
    respond_to do |format|
      format.html { redirect_to broadcast_messages_url, notice: 'Broadcast message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_broadcast_message
      @broadcast_message = BroadcastMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def broadcast_message_params
      params.require(:broadcast_message).permit(:content, :chatroom_id)
    end
end
