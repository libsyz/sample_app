class SessionsController < ApplicationController
      # before_action :login_params, only: [:create]

  def new

  end

  def create

    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])

      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = "Successfully logged in"

      redirect_to user_path(user)
      #log in the user
      #redirect to the show page
    else
      flash.now[:danger] = "Wrong email/password combination"
      render 'new'
     end

  end


  def destroy
    log_out if logged_in?
    flash[:primary] = "You logged out"
    redirect_to root_url
  end


  private

  # def login_params
  #   params.require(:session).permit(:email, :password)
  # end

end
