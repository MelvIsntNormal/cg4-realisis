# Define a new Class which inherits from the Application controller
class SessionsController < ApplicationController
  # Skkip execution of the isAuth filter on the create method
  skip_before_filter :isAuth, only: [:create]

  # Define new Controller Action method: authenticates a user
  def create
    # Find the user by their name
    user = User.find_by(name: params[:session][:name].downcase)
    # If the user exists and the user credentials are correct
    if user && user.authenticate(params[:session][:password])
      # Log the user in
      login user
      # Take the user to their profile page
      redirect_to me_path
    else
      # Notify the user that their credentials are incorrect
      flash[:error] = 'Invalid email/password combination'
      # Redirect to the home page
      redirect_to root_path
    end
  end

  # Define new Controller Action methid: ends a session
  def destroy
    # Logs the user out
    logout
    # Takes the user to the homepage
    redirect_to root_url
  end
end
