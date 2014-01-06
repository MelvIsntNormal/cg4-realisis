# Define a new class which inherits from the Application Controller
class StaticPagesController < ApplicationController
  # Skip the execution of the isAuth method for this whole class
  skip_before_filter :isAuth
  
  # Define new Controller Action method: renders the home page
  def index
    # If someone is signed in on the browser
    if signed_in?
      # Take the user to their profile page
      redirect_to "/#{@current_user.name}"
      # Abort execution
      return
    end
    
    # Don't use an application layout.
    render layout: false
  end
  
end
