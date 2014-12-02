class UsersController < ApplicationController
  def new
	@user = User.new
  end

  def create
	@user = User.new(user_params)
	Rails::logger.debug "*************************************" + user_params
	if @user.save
		session[:user_id]=@user.id
		@userSession = @user.id 
		@userFirstname = @user.first_name 
		@userLastname = @user.last_name
		respond_to do |format|
			format.html {redirect_to root_url }
			format.json { render :json => {:success => 1, :message => "Utilisateur creer", :userSessionID => @userSession, :userFirstnameID => @userFirstname, :userLastnameID => @userLastname} }
		end
    else
		respond_to do |format|
			format.html { render :action => "new" }
			format.json { render :json => {:success => 0, :message => "Utilisateur non creer"} }
		end
    end
  end
  
#	if @user.save
#		session[:user_id]=@user.id
#		redirect_to root_url
#	else
#		render :action => "new"
#	end
# end
  
  private
   def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
    end
end
