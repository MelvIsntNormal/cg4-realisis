class UsersController < ApplicationController
  skip_before_filter :isAuth, :only => [:new, :create]
  before_action :correct_user, only: [:edit, :update]
  
  def index
    @users = Users.all
  end
  
  def show
    @user = User.find_by(name: params[:name])
  end
  
  def me
    redirect_to "/#{@current_user.name}"
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    @user.playchar = 0
    @user.character_limit = 3
    # @user.characters = 0
    if @user.save
      login @user
      flash[:success] = "Welcome to Realisis, #{@user.name}!"
      redirect_to me_path
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Update Complete! (Allow a couple of minutes for changes to be visible to others, although this is usually instant)"
      redirect_to me_path
    else
      render 'edit'
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def correct_user
      @user = User.find_by(name: params[:name])
      redirect_to(root_url) unless current_user?(@user)
    end
  
end