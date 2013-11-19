class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  before_filter :isAuth
  before_action :locked
  
  private
  
    def isAuth
      redirect_to root_path unless signed_in?
    end

    def locked

    end

  def admin_user
    redirect_to me_path unless current_user.admin?
  end
end
