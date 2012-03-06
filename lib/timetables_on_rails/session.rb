require_relative './token'

module TimetablesOnRails
  class Session

    def initialize(key, session, cookies)
      @key, @session, @cookies = key, session, cookies
    end

    def create(permanent=false)
      token = Token.generate
      @session[@key] = token
      @cookies.permanent[@key] = token if permanent
    end

    def create_permanent
      create true 
    end

    def token
      @session[@key] || @cookies[@key]
    end

    def active?
      not @session[@key].nil?
    end

    def permanent?
      not @cookies[@key].nil?
    end

    def destroy
      @cookies[@key] = nil
      @session[@key] = nil
    end

  end
end
