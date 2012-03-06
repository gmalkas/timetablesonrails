# encoding: utf-8
class HomeController < ApplicationController

  def index
    if current_user
      render 'dashboard'
    else
      render 'index', :layout => 'sign_in'
    end
  end

  def sign_in
    if current_user
      redirect_to root_path
      return
    end

    user = User.find_by_username params[:username]

    if user && TimetablesOnRails::UserAuthentification.authenticate(user, params[:password])
      permanent = params[:remember_me] == '1'
      user_session = TimetablesOnRails::UserSession.new session, cookies
      user_session.create user, permanent
      redirect_to root_path
    else
      @sign_in_error = "Nom d'utilisateur ou mot de passe incorrect"
      render 'index', :layout => 'sign_in'
    end
  end

  def sign_out
    user_session = TimetablesOnRails::UserSession.new session, cookies
    user_session.destroy
    redirect_to root_path
  end
end
