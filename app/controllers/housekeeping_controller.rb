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
    @lock = @user.lock
    @infractions = @user.active_infractions
    @expired_infractions = @user.expired_infractions
  end
  
  def updateuser
    @user = User.find(params[:user][:id])
    case params[:commit]
      when "Add Admin", "Remove Admin"
        @user.toggle!(:admin)
    end

    redirect_to "hk/users/#{@user.name}"
    return
  end
  
  def tickets
    @my_tickets = @current_user.tickets
    @open_tickets = Ticket.all.where(open: true, assigned_id: nil)
  end
  
  def showticket
    @ticket = Ticket.find(params[:id])
    @addinfo = JSON.parse(@ticket.addinfo).symbolize_keys
  end
  
  def updateticket
    @ticket = Ticket.find(params[:id])
    case params[:commit]
      when "Capture Ticket"
        @ticket.assign_to!(@current_user.id) unless @ticket.assigned?
      when "Release Ticket"
        @ticket.assign_to!(nil) unless !current_user?(@ticket.assigned_id)
      when "Close Ticket"
        @ticket.action_taken = params[:ticket][:action_taken]
        @ticket.open = false
        @ticket.save!
        redirect_to "/hk/tickets/list"
    end
  end
end
