class SessionsController < ApplicationController


  def show  
  end
  
  
  def new
	@user = User.authenticate(params[:email], params[:password])
	if @user
		session[:user_id]=@user.id
		@userSession = @user.id 
		@userFirstname = @user.first_name 
		@userLastname = @user.last_name
		#, :userSessionID => @userSession, :userFirstnameID => @userFirstname, :userLastnameID => @userLastname
		respond_to do |format|
			format.html {redirect_to root_url }
			format.json { render :json => {:success => 1, :message => "Utilisateur valide"} }
		end
    else
		session[:user_id] = nil
		respond_to do |format|
			format.html { render :new, notice: "Les identifiants saisis ne sont pas corrects" }
			format.json { render :json => {:success => 0, :message => "Utilisateur non valide"} }
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
