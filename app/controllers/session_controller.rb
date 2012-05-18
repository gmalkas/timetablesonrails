# encoding: utf-8

##
#
# = SessionController
#
# Handles session creation and session destruction. This controller is the only
# one that does not require the user to be logged in.
#
class SessionController < ApplicationController

  skip_before_filter :require_login

  def sign_in!
    user = User.find_by_username params[:username]

    if user && TimetablesOnRails::UserAuthentification.authenticate(user, params[:password])
      permanent = params[:remember_me] == '1'
      user_session = TimetablesOnRails::UserSession.new session, cookies
      user_session.create user, permanent
      redirect_to :back
    else
      @sign_in_error = "Nom d'utilisateur ou mot de passe incorrect"
      render 'sign_in', layout: 'sign_in'
    end
  end

  def sign_out
    user_session = TimetablesOnRails::UserSession.new session, cookies
    user_session.destroy
    redirect_to root_path
  end
end
