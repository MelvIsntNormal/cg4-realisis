# Define a new class which inherits from the Application Controller
class HousekeepingController < ApplicationController
  # Run the admin_user method beforeevery Controller Action in this class
  before_action :admin_user
  
  # Define new Controller Action method: renders the housekeeping index page
  def index
  end

  # Define new Controller Action method: renders a page with a list of users
  def users
    # Get all user records
    @users = User.all
  end
  
  # Define new Controller Action method: renders a page with all user information, except sensitive information
  def showuser
    # Find a user by their username
    @user = User.find_by_name(params[:name])
    # Get all the users chat messages
    @chat_messages = @user.chat_messages
    # Get the user's lock record, if there is one
    @lock = @user.lock
    # Get a list of the users active infractions
    @infractions = @user.active_infractions
    # Get a list of the users expired infractions
    @expired_infractions = @user.expired_infractions
  end
  
  # Define new Controller Action method: updates a user record
  def updateuser
    # Find a user by their ID number
    @user = User.find(params[:user][:id])
    # Case statement considering the text on the submit button
    case params[:commit]
      # If it reads "Add Admin" or "Remove Admin"
      when "Add Admin", "Remove Admin"
        # Togge the boolean value of the admin field
        @user.toggle!(:admin)
    end
    
    # Redirecct the browser to the users page in Housekeepingf
    redirect_to "/hk/users/#{@user.name}"
    # End method execution
    return
  end
  
  # Define new Controller Action method: Shows a list of tickets
  def tickets
    # Gets all tickets associated with the currently logged in administrator
    @my_tickets = @current_user.tickets
    # Gets all open, unassigned tickets
    @open_tickets = Ticket.all.where(open: true, assigned_id: nil)
  end
  
  # Define new Controller Action method: shows the details of a single ticket
  def showticket
    # Gets a single Ticket record by its ID
    @ticket = Ticket.find(params[:id])
    # Convert the JSON string in the addinfo field to a hash, and convert the hash keys to symbols
    @addinfo = JSON.parse(@ticket.addinfo).symbolize_keys
  end
  
  # Define new Controller Action method: updayes a ticket record
  def updateticket
    # Gets a single ticket record by its ID
    @ticket = Ticket.find(params[:id])
    # Case statement considering the text on the submit button
    case params[:commit]
      # If the button reads "Capture Ticket"
      when "Capture Ticket"
        # Assign the ticket to the current admin unless the ticket has already been assigned to another admin
        @ticket.assign_to!(@current_user.id) unless @ticket.assigned?
      # If the button reads "Release Ticket"
      when "Release Ticket"
        # Change assignment to no one
        @ticket.assign_to!(nil)
      # If the butoon reads "Close Ticket"
      when "Close Ticket"
        # Set the action taken field
        @ticket.action_taken = params[:ticket][:action_taken]
        # Set the open field to false
        @ticket.open = false
        # Save the ticketrecordin the database
        @ticket.save!
        # Redirect the browser to the list of tickets
        redirect_to "/hk/tickets/list"
    end
  end
end
