# The server requires the em-websocket gem
require 'em-websocket'
# Import the configurations from a YAML file
EVENTCHAT_CONFIG = YAML.load_file("#{Rails.root}/config/serverconfig.yml")[Rails.env].symbolize_keys

# Generated code
include ERB::Util

# Do not close thread if an exception is raised
Thread.abort_on_exception = false

# Create a new Thread
Thread.new do
  # Run the Event machine
  EventMachine.run do
    # Array for connected clients
    @clients = Array.new

    # Start the WebSocket Server
    EventMachine::WebSocket.start(EVENTCHAT_CONFIG) do |ws|
      # When the server opens a new connection:
      ws.onopen do
        
      end

      # When the server closes a connection
      ws.onclose do
        # Find the disconnected client
        index = @clients.index {|i| i[:socket] == ws}
        # Remove the disconected clients from the array of connected clients
        client = @clients.delete_at index
        # Create Response Hash
        response = {
            action: "disconnect", # Client has disconnected
            user: client[:name], # Name of person who disconnected
          }
        # Send response JSON to each connected client
        @clients.each {|s| s[:socket].send JSON.generate(response)}
      end

      # When a new message is recieved
      ws.onmessage do |msg|
        # Convert JSON to hash
        client = JSON.parse(msg).symbolize_keys
        #If message comes from a new connection
        if client[:action] == 'init'
          # Find the correct user by the session token
          @user = User.find_by(remember_token: User.encrypt(client[:token]))
          # Add new client to array of connected clients
          @clients.push({ id: @user.id, name: @user.name , socket: ws})
          # Generate Response:
          response = {
            action: "new_user", # New user has joined room
            user: @user.id, # The ID of the user who joined
            name: @user.name # The name of the user
          }
          # Send JSON responses to all connected clients
          @clients.each {|s| s[:socket].send JSON.generate(response)}
        else
          # Get the sender's position in the array
          sender = @clients.index {|i| i[:socket] == ws}
          # Get the senders record
          sender = @clients[sender]
          # Consider the action invoked
          case client[:action]
            # If a new message is being sent
            when 'message'
              # Generate response
              response = {
                action: "new_msg", # New message
                name: sender[:name], # The user who sent it
                msg: h(client[:msg]) # The message with html tags escaped.
              }
              # Save the chat message into the database
              @msg = ChatMessage.new(user_id: sender[:id], message: response[:msg])
              @msg.save
              # Send the message to all clients
              @clients.each {|s| s[:socket].send JSON.generate(response)}
          end
        end
      end
    end
  end
end
