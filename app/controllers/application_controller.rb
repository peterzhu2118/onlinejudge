class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :authenticate_user!

  def after_sign_in_path_for(resource)
    '/panel'
  end
end
