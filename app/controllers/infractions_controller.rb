# Define a new class which inherits from the Application Controller
class InfractionsController < ApplicationController
  # Execute the admin_user filter before all controller actions in this class
  before_action :admin_user

  # Define new Controller Action method: renders a form for the creation of a new infraction
  def new
    # Find the correct user by its ID
    @user = User.find(params[:user_id])
    # Create an unsaved Infraction associated with the user
    @infraction = @user.infractions.build
  end

  # Define new Controller Action method: creates a new infraction
  def create
    # Find the correct user by its ID
    @user = User.find(params[:user_id])
    # Gets the user's lock
    @lock = @user.lock
    #  Create an unsaved infraction record with the data from the form linked to the correct user
    @infraction = @user.infractions.build(infraction_params)
    # Link the infraction to the current Admin
    @infraction.admin_id = current_user.id
    # Save the infraction
    @infraction.save

    # If a lock is required as well
    if params[:commit] == "Lock Account"
      # Create an unsaved lock linked to the correct user with the data from the form
      @lock = @user.build_lock(lock_params)
      # Associate the lock with the current admin
      @lock.locked_by = current_user.id
      # Save the lock record in the database
      @lock.save
    end
    # Get an array of the users infractions
    @infractions = @user.infractions
  end
 
  # Define new Controller Action method: shows the details of a single infraction
  def show
    # Find the correct user by their ID
    @user = User.find(params[:user_id])
    # Find the correct infraction by its ID
    @infraction = Infraction.find(params[:id])
  end

  # Define new Controller Action method: Renders a form to edit the infraction
  def edit
    # Find the correct user by their ID 
    @user = User.find(params[:user_id])
    # Find the correct infraction by its ID
    @infraction = Infraction.find(params[:id])
  end

  # Define new Controller Action method: Updates a single infraction record
  def update
    # Find the correct user by their ID 
    @user = User.find(params[:user_id])
    # Get the users Lock record
    @lock = @user.lock
    # Get an array of the users active infractions
    @infractions = @user.active_infractions
    # Get an array of the users expired infractions
    @expired_infractions = @user.expired_infractions
    # Find the correct infraction by its ID
    @infraction = Infraction.find(params[:id])
    # Update the infraction record with the data in the form
    @infraction.update_attributes(infraction_params)
    # Change the admin relationship to the person who edited the infraction
    @infraction.update_attribute(:admin_id, current_user.id)
  end
  
  # Define new Controller Action method: destroys infraction records
  def destroy
    # Get the correct user record by its ID number
    @user = User.find(params[:user_id])
    # Get the correct infraction by its ID number
    @infraction = Infraction.find(params[:id])
    # Destroy the infraction record
    @infraction.destroy!
  end

  # Define Private methods: can only be accessed by this class
  private
    # Define new Private Strong Parameters method: returns the permitted parameters
    def infraction_params
      # Return only the permitted parameters as a hash
      params.require(:infraction).permit(:desc, :permanent, :points)
    end

    # Define new Private Strong Parameters method: returns the permitted parameters
    def lock_params
      # Return only the permitted parameters as a hash: this uses the infraction parameters because the data saved for
      # infractions and locks are the same, except locks do not have a points field, hence why points are ommited here
      params.require(:infraction).permit(:desc, :permanent)
    end
end
