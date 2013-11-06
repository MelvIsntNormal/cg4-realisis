serverloc = 'ws://localhost:8080/'
ws = null

$ ->
  
  $('#new_message').submit  (e)=>
    e.preventDefault()
  
  $('#btnSend').click(sendMessage)
  
  $('#mymsg').keypress (e)=>
    if e.keyCode == 13
      $('#btnSend').click
      
  if window.WebSocket?
    ws = new WebSocket(serverloc)
  else
    $('#mymsg').attr('placeholder', "Error...")
    addMessage('error', 'Outdated Browser', 'Get a new HTML5 browser from <a href="http://html5test.com">html5test.com</a>')
    
    
  ws.onopen = =>
    console.log("Connection Open")
    init =
      action: "init"
      token:  $.cookie('remember_token')
      
    console.log(JSON.stringify(init))
    ws.send(JSON.stringify(init))
    
  ws.onerror = (e)=>
    console.log(e)
    
  ws.onclose = =>
    console.log("Closed")
    addMessage('error', 'Connection Error', 'Something went wrong while connecting to the server. Check your internet connection and wait a few minutes before trying again. If you still cant connect, there must be a problem on our side. We will try to get it fixed as soon as. Sorry about that :(')
    
  ws.onmessage = (m)=>
    console.log("Recieved: #{m.data}")
    m = JSON.parse(m.data)
    switch m.action
      when "new_user"
        if gon.current_user.name = m.name
          console.log("Authenticated")
          activate()
          
        addMessage("new-user", "#{m.name} joined the room!")
        
      when "new_msg"
        if gon.current_user.name = m.name
          console.log("Sent succesfully")
          activate()
          
        addMessage("msg", "#{m.name} says:", "#{m.msg}")
        
      when "disconnect"
        addMessage("new-user", "#{m.name} left the room.")
          
        
        
addMessage = (tpe, title, msg) ->
  html = "<div class='#{tpe}'>#{title} <hr>#{msg}</div>"
  $("#room").append(html)
  
activate = ->
  $('#mymsg').prop("disabled", false)
  $('#mymsg').attr("placeholder", "Enter message...")
  $('#btnSend').prop("disabled", false)

sendMessage = ->
  mymessage = $('#mymsg').val()
  $('#mymsg').val('')
  $('#mymsg').prop("disabled", true)
  $('#mymsg').attr("placeholder", "Sending...")
  $('#btnSend').prop("disabled", true)
  msg =
    action: 'message'
    msg: mymessage
    sender: gon.current_user.name
    
  console.log(JSON.stringify(msg))
  ws.send(JSON.stringify(msg))
