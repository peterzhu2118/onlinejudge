class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :require_login

private

  def require_login
    if (request.original_fullpath != '/' && request.original_fullpath != '/login')
      unless User.find_by(email: session[:email])
        redirect_to '/login' 
      end
    end
  end
end
