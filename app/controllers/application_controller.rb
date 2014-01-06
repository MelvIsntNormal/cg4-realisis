# Define new Controller Class which inherits from the Base Controller Class
class ApplicationController < ActionController::Base
  # Generated code 
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # End Generated code

  # Include a module dealing with user sessions
  include SessionsHelper
  
  # Execute before all Controller Actions in this AND child classes
  before_filter :isAuth
  
  # Define Private methods: can only be accessed by this and child classes
  private

    # Define new Filter method: checks to see if a user is logged in
    def isAuth
      # Redirect the browser to the homepage, unless the user is logged in
      redirect_to root_path unless signed_in?
      # Execute the 'locked' method unless the user does not have a lock associated with their account
      locked unless current_user.lock == nil
    end
    
    # Define new method: checks to see if a lock should be enforced
    def locked
      # Get the current user
      user = current_user
      # If the lock has passed its expiry date, and the lock is not permanent
      if user.lock.expires_at <= Time.now && !user.lock.permanent?
        # Destroy the lock record
        user.lock.destroy!
      end
      # If the account is still locked
      if user.lock != nil
        # Notify the user that their account has been locked
        flash[:error] = "Your account has been locked. Please contact Player Support for more information"
        # Log the user out
        logout
        # Take the user to the homepage
        redirect_to root_path
      end
    end
    
    # Define new Filter method: checks to see if the user is an admin
    def admin_user
      # Redirect the user to their profile page unless the user is an admin
      redirect_to me_path unless current_user.admin?
    end
end
