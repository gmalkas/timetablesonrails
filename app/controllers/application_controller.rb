require 'timetablesonrails/user_session'

class ApplicationController < ActionController::Base

  include TimetablesOnRails

  protect_from_forgery

  def current_user
    @user_session ||= UserSession.new session, cookies
    @user_session.current_user
  end

  helper_method :current_user
end
