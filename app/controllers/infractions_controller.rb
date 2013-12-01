class InfractionsController < ApplicationController
  before_action :admin_user
  def new
    @user = User.find(params[:user_id])
    @infraction = @user.infractions.build
  end

  def create
    @user = User.find(params[:user_id])
    @lock = @user.lock
    @infraction = @user.infractions.build(infraction_params)
    @infraction.admin_id = current_user.id
    @infraction.save

    if params[:commit] == "Lock Account"
      @lock = @user.build_lock(lock_params)
      @lock.locked_by = current_user.id
      @lock.save
    end
  end

  def show
    @user = User.find(params[:user_id])
    @infraction = Infraction.find(params[:id])
  end

  def edit
    @user = User.find(params[:user_id])
    @infraction = Infraction.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @lock = @user.lock
    @infractions = @user.active_infractions
    @expired_infractions = @user.expired_infractions
    @infraction = Infraction.find(params[:id])
    @infraction.update_attributes(infraction_params)
    @infraction.update_attribute(:admin_id, current_user.id)
  end

  def destroy
    @user = User.find(params[:user_id])
    @infraction = Infraction.find(params[:id])
    @infraction.destroy!
  end

  private

    def infraction_params
      params.require(:infraction).permit(:desc, :permanent, :points)
    end

    def lock_params
      params.require(:infraction).permit(:desc, :permanent)
    end
end
