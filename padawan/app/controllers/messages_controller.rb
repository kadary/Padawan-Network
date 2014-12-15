class MessagesController < ApplicationController
	before_filter :set_user
 
	def index
		if params[:mailbox] == "sent"
			@messages = @user.sent_messages
		elsif params[:mailbox] == "inbox"
			@messages = @user.received_messages
		#elsif params[:mailbox] == "archieved"
			# @messages = @user.archived_messages
		end
	end

  # GET /messages/1
  # GET /messages/1.json
  def show
  @message = Message.readingmessage(params[:id],current_user.id)
  end

  # GET /messages/new
  def new
    @message = Message.new
	if params[:reply_to]
		@reply_to = User.find_by_user_id(params[:reply_to])
		unless @reply_to.nil?
			@message.recepient_id = @reply_to.current_user.id
		end
	end
  end
  
  def delete_multiple
	if params[:delete]
		params[:delete].each { |id|
			@message = Message.find(id)
			@message.mark_message_deleted(@message.id,current_user.id) unless @message.nil?
		}
	flash[:notice] = "Messages deleted"
	end
	redirect_to user_messages_path(@user, @messages)
 end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)
	#@message.sender_id = @user.padawan_id
	@message.sender_id = current_user.id

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message cree.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message mis a jour.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message detriut.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end
	
	def set_user
		@user = current_user
	end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:sender_id, :recepient_id, :sender_deleted, :subject, :body, :read_at, :container)
    end
	
	def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
     end
end
