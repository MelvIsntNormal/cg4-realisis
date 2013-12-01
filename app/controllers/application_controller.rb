class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  before_filter :isAuth
  
  private
  
    def isAuth
      redirect_to root_path unless signed_in?
      locked
    end

    def locked
      user = current_user
      if user.lock != nil
        flash[:error] = "Your account has been locked. Please contact Player Support for more information"
        logout
        redirect_to root_path
      end
    end

  def admin_user
    redirect_to me_path unless current_user.admin?
  end
end
