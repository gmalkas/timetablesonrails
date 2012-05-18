# encoding: utf-8

##
# = ApplicationController
#
# All controllers extend this controller, except SessionController.
# This controller ensures the user is logged in, and defines some helpers methods.
# Lastly, it defines callbacks to deal with some common exceptions.
#
class ApplicationController < ActionController::Base

  protect_from_forgery

	rescue_from ActiveRecord::RecordNotFound, with: :not_found
	rescue_from ActionController::RoutingError, with: :not_found
	rescue_from Errno::ECONNREFUSED, with: :unavailable
  rescue_from CanCan::AccessDenied, with: :unauthorized

  # Ensure the user is logged in
  before_filter :require_login

	private

  def require_login
    unless logged_in?
      render 'session/sign_in', layout: 'sign_in'
    end
  end

  ##
  # 
  # Renders a 404 error message in case there is a RecordNotFound exception or a RountingError.
  #
  # == Note
  #
  # This could be improved since the error message is not really helpful for the user. The message
  # should be specific to the resource that is missing. One way to do that would be to override this method
  # in controllers to render a specific view.
  #
  def not_found
    render "errors/404", :status => 404
  end

  ##
  #
  # Renders a 401 error message in case there is a Cancan::AccessDenied exception.
  #
	def unauthorized
    render "errors/401", :status => 401
	end

  ##
  # 
  # Render a  503 error message in case there is a Errno::ECONNREFUSED exception. This is necessary
  # since we use a LDAP to sign in users.
  #
	def unavailable
    render "errors/503", :status => 503 
	end

  ##
  # 
  # Fetches the user associated with the current session, and returns it.
  #
  # == Returns
  #
  # An instance of User, or nil.
  #
  def current_user
    @user_session ||= TimetablesOnRails::UserSession.new session, cookies
    @user_session.current_user
  end

  def logged_in?
    !!current_user
  end

  helper_method :current_user, :logged_in?
end
