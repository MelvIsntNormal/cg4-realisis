class StaticPagesController < ApplicationController
  skip_before_filter :isAuth
  
  def index
    if signed_in?
      redirect_to "/#{@current_user.name}"
      return
    end
    
    render layout: false
  end
  
  def jdebug
    render layout: false
  end
  
end
