# Define a new class which inherits from the Application Controller
class UsersController < ApplicationController
  skip_before_filter :isAuth,   only: [:new, :create] # Ignore the isAuth method for the new and create methods
  before_action :correct_user,  only: [:edit, :update] # Execute the correct_user methods before execution of the edit and update methods
  
  # Define new Controller Action method: displays the profile page of one user
  def show
    @user = User.find_by(name: params[:name]) # Find a User in the database with the specified name
  end
  
  # Define new Controller Action method: redirects to the currently logged in user's profile page
  def me
    redirect_to "/#{@current_user.name}" # Redirects to the currently logged in user's profile page
  end
  
  # Define new Controller Action method: renders a form for the creation of a new user
  def new
    @user = User.new # Creates a blank, unsaved User record
  end
  
  # Define new Controller Action method: saves a new user in the database
  def create
    @user = User.new(user_params) # Creates an unsaved User record filled with the form data from the 'new' form 
    if @user.save # If the user saves in the database succesfully
      login @user # Logs the user in
      flash[:success] = "Welcome to Realisis, #{@user.name}!" # Shows a welcome notification on the next page
      redirect_to me_path # Redirects the user to the user's profile page
    else
      render 'new' # Renders the 'new' form with errors
    end
  end

  # Define new Controller Action method: renders a form for editing a user
  def edit
  end
  
  # Define new Controller Action method: updates a user record
  def update
    @user = User.find(params[:id]) # Find a user by an ID number
    if @user.update_attributes(user_params) # If the uuser record updates succesfully
      # Notify the user
      flash[:success] = "Update Complete! (Allow a couple of minutes for changes to be visible to others, although this is usually instant)"
      redirect_to me_path # Show the user's profile page
    else # If updating was not succesfull
      render 'edit' # Re-render the edit form
    end
  end

  # Define new Controller Action method: destroys a user record
  def destroy
    @user = User.find(params[:user][:id]) # Find the user by an ID number
    @user.destroy! # Destrou the user
    redirect_to users_list_path # Redirect to the list of users
  end
  
  private # Private methods restricted to this class only
    # Define new Private Strong Parameters method: returns the permitted parameters
    def user_params
      # Return only the permitted parameters as a hash
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # Define new Private Filter method: determines id the currently logged in user is attempting to access their own data
    def correct_user
      # Find the user by name
      @user = User.find_by(name: params[:name])
      # Redirect to the homepage unless the user is trying to edit their own data
      redirect_to(root_url) unless current_user?(@user)
    end
end
