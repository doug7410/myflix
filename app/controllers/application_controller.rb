class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?, :video_is_in_queue?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id] && User.any?
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:error] = "You must be logged in to do that."
      redirect_to sessions_new_path
    end
  end
end
