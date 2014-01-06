# Define a Database model for tickets
class Ticket < ActiveRecord::Base
  # Tickets are assigned to admins, which are classsed as users
  belongs_to :assigned, class_name: "User"
  # Tickets are sent by users
  belongs_to :sender, class_name: "User"
   
  # Define new Model method: assigns an admin to the ticket (Takes an integer parameter)
  def assign_to! (id)
    # If the ticket is to be released (id is nil
    if id == nil
      # Set the assignment to no one and exit execution
      update_attribute :assigned_id, nil
      return
    end
    # If the user specified is an administrator
    if User.find(id).admin?
      # Set the assignment to that admin and exit execution
      update_attribute :assigned_id, id
      return
    end 
  end

  # Define new Model method: returns a boolean value depending on the assignment of the ticket
  def assigned?
    # Returns true if the assigned_id is not nil, returns false if otherwise
    assigned_id != nil
  end
  
end
