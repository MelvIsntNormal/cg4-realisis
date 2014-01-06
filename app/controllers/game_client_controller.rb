# Define a new class which inherits from the Application Controller
class GameClientController < ApplicationController
  # Define new Controller Action method: renders the chat room
  def play
    # Tell ActiveRecord not to encapsulate JSON data in a single root object
    ActiveRecord::Base.include_root_in_json = false
    # Save a hash of a user record: convert it to JSON and back to get it into the correct hash form. Turn hash keys into a symbol key
    @user = JSON.parse(current_user.to_json(include: :friends)).symbolize_keys
    # Save the user has as a Gon variable. This allows the hash to be accessed via JavaScript
    gon.current_user = @user
    # Create a blank, unsaved Chat message record
    @chat_message = ChatMessage.new
    # Don't use any layout while rendering the page
    render layout: false
  end
end
