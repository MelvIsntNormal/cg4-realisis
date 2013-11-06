class RelationsController < ApplicationController

  def create
    @user = User.find(params[:relation][:character_id])
    case params[:relation][:reltype]
      when "freq"
        current_user.req_friend!(@user)
      
      when "friend"
        current_user.add_friend!(@user)
    end
    
    respond_to do |format|
      format.html { redirect_to "/#{@user}" }
      format.js
    end
  end

  def destroy
    @user = Relation.find(params[:id]).character
    @other_user = Relation.find(params[:id]).owner
    case Relation.find(params[:id]).reltype
      when "freq"
        current_user.rej_friend!(@other_user)
        
      when "friend"
        current_user.rm_friend!(@user)
        
    end
    respond_to do |format|
      format.html { redirect_to "/#{@user}" }
      format.js
    end
  end
end