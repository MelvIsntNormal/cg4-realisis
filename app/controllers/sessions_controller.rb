class SessionsController < ApplicationController
  skip_before_filter :isAuth, only: [:new, :create]
  def new
  end

  def create
    user = User.find_by(name: params[:session][:name].downcase)
    if user && user.authenticate(params[:session][:password])
      login user
      redirect_to me_path
    else
      flash.now[:error] = 'Invalid email/password combination'
      redirect_to root_path
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
end