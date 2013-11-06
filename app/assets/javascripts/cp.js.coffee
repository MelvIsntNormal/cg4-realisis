$ ->
  $("#cp").accordion()
  
  if window.WebSocket?
    socket = new WebSocket("ws://localhost:8080") 
  
  socket.onopen = =>
    console.log("Connection Open")
    init =
      sender: "ignore"
      action: "test"
      token:  "#"
    
    socket.send(JSON.stringify(init))
    
  socket.onerror = (e)=>
    console.log(e)
    
  socket.onclose = =>
    console.log("Closed")
    
  socket.onmessage = (m)=>
    console.log("Recieved: #{m.data}")
    msg = m.data.JSON.parse
    switch msg.action
      when "ret_init"
        console.log("Authenticated")
