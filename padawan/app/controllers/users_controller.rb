class UsersController < ApplicationController
  def new
	@user = User.new
  end

  def create
	@user = User.new(user_params)
	if @user.save
		session[:user_id]=@user.id
		redirect_to root_url
	else
		render :action => "new"
	end
  end
  
  private
   def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
    end
end
