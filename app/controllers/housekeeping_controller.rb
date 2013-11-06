class HousekeepingController < ApplicationController
  before_action :admin_user
  
  def index
    
  end

  def users
    
  end

  def edit
    
  end
  
  private
  
    def admin_user
      redirect_to me_path unless current_user.admin?
    end
end
