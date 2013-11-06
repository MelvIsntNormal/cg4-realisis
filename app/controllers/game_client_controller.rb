class GameClientController < ApplicationController
  def play
    ActiveRecord::Base.include_root_in_json = false
    @user = JSON.parse(current_user.to_json(except: :characters, include: :friends)).symbolize_keys
    gon.current_user = @user
    @chat_message = ChatMessage.new
    
    render layout: false
  end
end
