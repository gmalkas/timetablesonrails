require_relative './session'

module TimetablesOnRails
  class UserSession

    def initialize(session, cookies)
      @session = Session.new :session_token, session, cookies
    end
    
    def create(user, permanent=false)
      @session.create permanent
      user.session_token = @session.token
      user.save!
    end

    def create_permanent
      create true 
    end

    def destroy
      @session.destroy
    end

    def active?
      @session.active?
    end

    def permanent?
      @session.permanent?
    end

    def current_user
      @current_user || retrieve_user
    end

    private

    def retrieve_user
      begin
        @current_user ||= User.find_by_session_token! @session.token if @session.active? or @session.permanent?
      rescue ActiveRecord::RecordNotFound
        destroy
        nil
      end
    end

  end
end
