class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def require_login
    unless session[:user_id]
      flash[:alert] = "You must be logged in to access this page."
      redirect_to login_path
    end
  end
end
