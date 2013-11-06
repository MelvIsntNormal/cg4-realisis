$ ->
  $('#mymsg').keypress (e)=>
    if e.keyCode == 13
      $('#btnSend').click
