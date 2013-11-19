require 'em-websocket'
EVENTCHAT_CONFIG = YAML.load_file("#{Rails.root}/config/serverconfig.yml")[Rails.env].symbolize_keys


include ERB::Util

Thread.abort_on_exception = false

Thread.new do
  EventMachine.run do
    @clients = Array.new
    
    EventMachine::WebSocket.start(EVENTCHAT_CONFIG) do |ws|
      ws.onopen do
        
      end

      ws.onclose do
        index = @clients.index {|i| i[:socket] == ws}
        client = @clients.delete_at index
        response = {
            action: "disconnect",
            user: client[:name],
          }
        @clients.each {|s| s[:socket].send JSON.generate(response)}
      end
    
      ws.onmessage do |msg|
        client = JSON.parse(msg).symbolize_keys
        if client[:action] == 'init'
          @user = User.find_by(remember_token: User.encrypt(client[:token]))
          @clients.push({ id: @user.id, name: @user.name , socket: ws})
          response = {
            action: "new_user",
            user: @user.id,
            name: @user.name
          }
          @clients.each {|s| s[:socket].send JSON.generate(response)}
        else
          sender = @clients.index {|i| i[:socket] == ws}
          sender = @clients[sender]
          case client[:action]
            when 'message'
              response = {
                action: "new_msg",
                name: sender[:name],
                msg: h(client[:msg])
              }
              @msg = ChatMessage.new(user_id: sender[:id], message: response[:msg])
              @msg.save
              @clients.each {|s| s[:socket].send JSON.generate(response)}
          end
        end
      end
      
      puts "WS Started"
    end
  end
end