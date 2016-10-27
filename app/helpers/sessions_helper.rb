module SessionsHelper
  def log_in (user)
    session[:email] = user.email
  end

  def current_user
    @current_user ||= User.find_by(email: session[:email])
  end

  def logged_in?
    !@current_user.nil?
  end

  def log_out
    session.delete(:email)
    @current_user = nil
  end
end
