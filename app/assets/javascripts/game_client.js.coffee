serverloc = "ws://localhost:8080/" # Location of the websocket server
ws = null # variable for WebSocket Connection

$ -> # jQuery: When DOM has loaded
  
  $('#new_message').submit  (e)=> # When the form is submitted
    e.preventDefault() # Do nothing
  
  $('#btnSend').click(sendMessage) # When send button is clicked, send the message
  
  $('#mymsg').keypress (e)=> # When the Enter/Return key is pressed while typing in the message box
    if e.keyCode == 13 # Keycode 13 = Enter/Return
      $('#btnSend').click # Trigger the send button Click event
      
  if window.WebSocket? # If the browser supports WebSockets
    ws = new WebSocket(serverloc) # Create a new WebSocket connection
  else # Otherwise...
    $('#mymsg').attr('placeholder', "Error...") # Change the placeholder text for the messagebox to Error
    # Output an error message to the chat stream
    addMessage('error', 'Outdated Browser', 'Get a new HTML5 browser from <a href="http://html5test.com">html5test.com</a>')
    
    
  ws.onopen = => # When the websocket connection is opened succesfully
    console.log("Connection Open") # Notify via the browser console
    init = # Initialisation data
      action: "init" # Action that needst o be done by the server
      token:  $.cookie('remember_token') # Remember Token string
      
    console.log(JSON.stringify(init)) # Ouput the JSON string to the console
    ws.send(JSON.stringify(init)) # Send the JSON string to the server
    
  ws.onerror = (e)=> # When a WebSocket error occurs, This event is triggered
    console.log(e) # Output the error to the console
    
  ws.onclose = => # Weh the WebSocket connection is closed
    console.log("Closed") # Output String to console
    # Output error message to chat room
    addMessage('error', 'Connection Error', 'Something went wrong while connecting to the server. Check your internet connection and wait a few minutes before trying again. If you still cant connect, there must be a problem on our side. We will try to get it fixed as soon as. Sorry about that :(')
    $('#mymsg').attr('placeholder', "Error...") # Set messagebox placeholder attribute ot "Error..."

  ws.onmessage = (m)=> # When a message is recieved
    console.log("Recieved: #{m.data}") # Log the message in the browser console
    m = JSON.parse(m.data) # Convert JSON to JS Object
    switch m.action # Case statement for the action required of the message
      when "new_user" # If a new user has joined the room
        if gon.current_user.name = m.name # If the user joined is the currently logged in user
          console.log("Authenticated") # Output string to console
          activate() # Enable Chat controls
          
        addMessage("new-user", "#{m.name} joined the room!") # Notify user that user has joined the room
        
      when "new_msg" # When a new chat message had been recieved
        if gon.current_user.name = m.name # if the currently logged in user sent the message
          console.log("Sent succesfully") # Output string to browser console
          activate() # Re-enable chat controls
          
        addMessage("msg", "#{m.name} says:", "#{m.msg}") # Show the message to the chatroom
        
        
addMessage = (tpe, title, msg) -> # New Function: adds a message to the chat room
  html = "<div class='#{tpe}'>#{title} <hr>#{msg}</div>" # Generate HTMl code to add to the room
  $("#room").append(html) # Add html string to the room
  
activate = -> # New Function: enables chat controls
  $('#mymsg').prop("disabled", false) # Enable the message box
  $('#mymsg').attr("placeholder", "Enter message...") # Change placeholder
  $('#btnSend').prop("disabled", false) # Enable the send button

sendMessage = -> # New Function: sends a chat message
  mymessage = $('#mymsg').val() # Get the text from the message box
  $('#mymsg').val('') # Empty the message box
  $('#mymsg').prop("disabled", true) # Disable the messagebox
  $('#mymsg').attr("placeholder", "Sending...") # Change the placeholder to show that the message is sending
  $('#btnSend').prop("disabled", true) # Disable the sending button
  msg = # Message data
    action: 'message' # Tells the server that this message should be processed as a new Chat Message
    msg: mymessage # The message text
    sender: gon.current_user.name # The name of the current user
    
  console.log(JSON.stringify(msg)) # Output JSON to the browser Console
  ws.send(JSON.stringify(msg)) # Send JSON to the server
