# Handles all dynamic processing for any request sent to Tickets
class TicketsController < ApplicationController
  # A Regular Expression for the format of a user tag
  USER_TAG_REGEX = /@((?:[a-z][a-z]+))/

  # When 'new' requested (handles new tickets):
  def new
    # Execute if the user hasn't exceeded their ticket allowance
    unless current_user.help_requests.where(open: true).count < 1
      # Redirect to their ticket list
      redirect_to ("/tickets")
      # Abort processing this method
      return
    end
    # Create a blank ticket associated with the currently logged in user.
    @ticket = current_user.help_requests.build
  end

  # When 'create' requested (handles saving new tickets):
  def create
    # Build a ticket associated with the current user and fill with strong parameters
    @ticket = current_user.help_requests.build(ticket_params)
    # New Hash
    add_info = {}
    # New Nested Array
    add_info[:tagged_users] = []
    # Scan for tagged users in the report:
    @ticket.desc.scan(USER_TAG_REGEX) do |name|
      # Find a tagged user in the database
      user = User.find_by_name(name)
      # Add the tagged user to the hash of tagged users
      add_info[:tagged_users] << user.name unless user == nil
    end
    # Save a JSON representation of the add_info hash to the record
    @ticket.addinfo = JSON.generate(add_info)
    # Save the new record in the database
    @ticket.save
    # Send the user to their homepage
    redirect_to me_path
  end

  # When 'show' requested (handles showing tickets)
  def show
    # Get the current user
    @user = User.find(current_user.id)
    # Define arrays to hold open and closed tickets
    @open_tickets = []
    @closed_tickets = []
    # For each request the person has made:
    @user.help_requests.each do |request|
      # If the request is open...
      if request.open?
        # ...add it to the array of open tickets
        @open_tickets << request
        # Else if the ticket is closed...
      elsif !request.open?
        # Add it to the list of closed tickets
        @closed_tickets << request
      end
    end
  end

  private # Private security functions

  # Strong Parameters for ticket:
  def ticket_params
    # Allow only the title and description parameters to be passed.
    params.require(:ticket).permit(:title, :desc)
  end
end