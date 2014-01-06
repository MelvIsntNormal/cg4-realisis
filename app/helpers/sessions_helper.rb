# Define a new Helper module: contains helper methods reated to Sessions
module SessionsHelper
  # Define new Helper method: Logs a user in (Takes a User parameter)
  def login(user)
    # Generate a new session token
    remember_token = User.new_remember_token
    # Store the token in a cookie
    cookies.permanent[:remember_token] = remember_token
    # Hash the token and store it in the database with the user record
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    # Set the currently logged in user
    self.current_user = user
  end
  
  # Define new Helper Attribute Writer method: invoked when setting the value of current_user (Takes a User parameter)
  def current_user=(user)
    # Set the currently logged in user
    @current_user = user
  end

  # Define new Helper Attribute Reader method: invoke when reading the value of current_user
  def current_user
    # Get a hash of the session token
    remember_token = User.encrypt(cookies[:remember_token])
    # Set the currently logged in user with the user found by the session token IF a user is found
    @current_user ||= User.find_by(remember_token: remember_token)
  end
  
  # Define new Helper method: returns a Boolean value depending onif the user provided is logged in (Takes a User parameter)
  def current_user?(user)
    # Compares the user parameter and the currently logged in user: returns true if both are the same
    user == current_user
  end
  
  # Define new Helper method: returns a boolean value depending on if a user is signed into the browser
  def signed_in?
    # Tests current user: if it is empty, returns false, if there is a user present, returns true
    !current_user.nil?
  end
  
  # Define new Helper method: logs a user out
  def logout
    # Set the current user to nil
    self.current_user = nil
    # Remove the session token cookie
    cookies.delete(:remember_token)
  end
end
