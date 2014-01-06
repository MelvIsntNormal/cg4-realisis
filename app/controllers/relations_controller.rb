# Define a new class which inherits from the Application Controller
class RelationsController < ApplicationController

  # Define new Controller Action method: creates a relationship record
  def create
    # Find a user by their ID
    @user = User.find(params[:relation][:character_id])
    # Considering the type of relationship to be created
    case params[:relation][:reltype]
      # If it is a friend request
      when "freq"
        # Request friendship with the other user
        current_user.req_friend!(@user)
      
      # If a friend request has been accepted
      when "friend"
        # Add friendship records to the database
        current_user.add_friend!(@user)
    end
    
  end

  # Define new Controller Action method: removes relationship records depending on action
  def destroy
    # Find the users who are associated with the relationship
    @user = Relation.find(params[:id]).character
    @other_user = Relation.find(params[:id]).owner
    # Consider the type of relationship
    case Relation.find(params[:id]).reltype
      # If it is a friend request
      when "freq"
        # Reject the request
        current_user.rej_friend!(@other_user)
        
      # If the two users are friends
      when "friend"
        # Remove friendship
        current_user.rm_friend!(@user)
        
    end
  end
end
