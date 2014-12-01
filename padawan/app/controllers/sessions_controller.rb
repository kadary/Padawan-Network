class SessionsController < ApplicationController


  def show  
  end
  
  
  def new
	@user = User.authenticate(params[:email], params[:password])
	
	respond_to do |format|
      if @user
		session[:user_id]=@user.id
        format.html {redirect_to root_url }
        format.json { render :json => {:success => 1, :message => "Session ouverte"} }
      else
		session[:user_id] = nil
        format.html { render :new, notice: "Les identifiants saisis ne sont pas corrects" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
	end
	
	
#	if @user
#		session[:user_id] = @user.id
#		redirect_to root_url
#	else
#		session[:user_id] = nil
#		render :action => "new"
#		flash[:notice] = "Les identifiants saisis ne sont pas corrects"
#	end
#  end

  def destroy
	session[:user_id] = nil
	redirect_to root_url
  end
end
