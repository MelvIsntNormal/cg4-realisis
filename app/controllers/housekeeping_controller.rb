class HousekeepingController < ApplicationController
  before_action :admin_user
  
  def index
    
  end

  def users
    @users = User.all
  end

  def showuser
    @user = User.find_by_name(params[:name])
    @chat_messages = @user.chat_messages
  end
  
  def updateuser
    @user = User.find(params[:user][:id])
    case params[:commit]
      when "Add Admin", "Remove Admin"
        @user.toggle!(:admin)
      when "Lock Account", "Unlock Account"
        @user.toggle!(:locked)
    end

    respond_to do |format|
      format.html { redirect_to "hk/users/#{@user.name}" }
      format.js
    end
  end
  
  def tickets
    @my_tickets = current_user.assigned_tickets
    @open_tickets = Ticket.all.where(open: true)
  end
  
  def showticket
    
  end
  
  def updateticket
    
  end
  
  private
  
    def admin_user
      redirect_to me_path unless current_user.admin?
    end
end
