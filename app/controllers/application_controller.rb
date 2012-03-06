class ApplicationController < ActionController::Base

  protect_from_forgery

	rescue_from ActiveRecord::RecordNotFound, :with => :not_found
	rescue_from Errno::ECONNREFUSED, :with => :unavailable

	private

  def not_found
    render "errors/404", :status => 404
  end

	def unauthorized
    render "errors/401", :status => 401
	end

	def unavailable
    render "errors/503", :status => 503 
	end

  def current_user
    @user_session ||= TimetablesOnRails::UserSession.new session, cookies
    @user_session.current_user
  end

  helper_method :current_user
end
