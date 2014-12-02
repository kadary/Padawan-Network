class StatusesController < ApplicationController
  # GET /status
  # GET /status.json
  def index
    @status = Status.find(:all, :order => 'status.created_at DESC')
      respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @status }
    end
  end

  # GET /status/1
  # GET /status/1.json
  def show
    @Status = Status.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @Status }
    end
  end


  # GET /status/1/edit
  def edit
    @Status = Status.find(params[:id])
  end

  # POST /status
  # POST /status.json
  def create
    @Status = Status.new(status_params)
    @Status.posted_by_uid = current_user.id
    @Status.posted_by = current_user.first_name+" "+current_user.last_name
    @Status.ups=0
    @Status.downs=0
    @Status.save
    respond_to do |format|
      if @Status.save
        format.html { redirect_to root_path }
        format.json { render :json => @Status, :status => :created, :location => @Status }
      else
        format.html { redirect_to root_path }
        format.json { render :json => @Status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /status/1
  # PUT /status/1.json
  def update
    @Status = Status.find(params[:id])

    respond_to do |format|
      if @Status.update_attributes(status_params)
        format.html { redirect_to @Status, :notice => 'Status was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @Status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /status/1
  # DELETE /status/1.json
  def destroy
    @Status = Status.find(params[:id])
    @Status.destroy

    respond_to do |format|
      format.html { redirect_to status_url }
      format.json { head :no_content }
    end
  end
  
  private
   def status_params
      params.require(:status).permit(:post, :posted_by, :posted_by_uid)
    end
	def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
     end
end

  
