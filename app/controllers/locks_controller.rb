# Define a new class which inherits from the Application Controller
class LocksController < ApplicationController
  # Execute the admin_user filter before all controller actions in this class
  before_action :admin_user

  # Define new Controller Action method: renders a form to create a new Lock
  def new
    # Finds the user by ID
    @user = User.find(params[:user_id])
    # Creates an unsaved Lock record associated with the user
    @lock = @user.build_lock
  end

  # Define new Controller Action method: saves a new Lock record to the database
  def create
    # Finds the user by ID
    @user = User.find(params[:user_id])
    # Creates an unsaved Lock record with the data from the 'new' form
    @lock = @user.build_lock(lock_params)
    # Get a list of the users active infractions
    @infractions = @user.active_infractions
    # Get a list of the users expired infractions
    @expired_infractions = @user.expired_infractions
    # Associates the lock with the admin that created it
    @lock.locked_by = current_user.id
    # Save the lock record into the database
    @lock.save
  end
 
  # Define new Controller Action method: renders a form to edit a lock
  def edit
    # Finds a user by ID
    @user = User.find(params[:user_id])
    # Gets the user's Lock record
    @lock = @user.lock
  end

  # Define new Controller Action method: updates a lock record with the data from the 'edit' form
  def update
    # Find the user by ID
    @user = User.find(params[:user_id])
    # Gets the user's Lock record
    @lock = @user.lock
    # Get a list of the user's active infractions
    @infractions = @user.active_infractions
    # Get a list of the user's expired infractions
    @expired_infractions = @user.expired_infractions
    # Updates the Lock record with the data from the edit form
    @lock.update_attributes(lock_params)
    # Re-associates the lock to the person who edited it
    @lock.update_attribute(:locked_by, current_user.id)
  end

  # Define new Controller Action method: destroys a Lock
  def destroy
    # Find the user by ID
    @user = User.find(params[:user_id])
    # Destroys the user's Lock record
    @user.lock.destroy!
  end
  
  # Define Private methods: can only be accessed by this class
  private
    
    # Define new Private Strong Parameters method: returns the permitted parameters
    def lock_params
      # Returns only the permitted paraeters
      params.require(:lock).permit(:desc, :permanent)
    end
end
