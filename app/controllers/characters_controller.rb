class CharactersController < ApplicationController
  
  def new
    @user = User.find_by(name: params[:name])
    @character = Character.new
  end
  
  def show
    @user = User.find_by(name: params[:name])
    @character = Character.find_by(username: params[:username])
  end
  
  def create
    @user = User.find_by(name: params[:name])
    @character = Character.new(character_params)
    @character.accountid = @user.id
    if @character.save
      # login @user
      # flash[:success] = "Welcome to Realisis, #{@user.name}!"
      # redirect_to "/#{@user.name}"
    else
      # render 'new'
    end
  end
  
  private
    def character_params
      params.require(:character).permit(:username)
    end
    
    def correct_user
      @user = User.find_by(name: params[:name])
      redirect_to(root_url) unless current_user?(@user)
    end
end