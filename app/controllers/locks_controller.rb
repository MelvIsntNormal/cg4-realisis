class LocksController < ApplicationController
  before_action :admin_user
  def new
    @user = User.find(params[:user_id])
    @lock = @user.build_lock
  end

  def create
    @user = User.find(params[:user_id])
    @lock = @user.build_lock(lock_params)
    @infractions = @user.active_infractions
    @expired_infractions = @user.expired_infractions
    @lock.locked_by = current_user.id
    @lock.save

    respond_to do |format|
      format.js
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @lock = @user.lock
  end

  def update
    @user = User.find(params[:user_id])
    @lock = @user.lock
    @infractions = @user.active_infractions
    @expired_infractions = @user.expired_infractions
    @lock.update_attributes(lock_params)
    @lock.update_attribute(:locked_by, current_user.id)

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @user.lock.destroy!
    respond_to do |format|
      format.html { redirect_to "/hk/users/#{@user.name}" }
      format.js
    end
  end

  private

    def lock_params
      params.require(:lock).permit(:desc, :permanent)
    end
end
