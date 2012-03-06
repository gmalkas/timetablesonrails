require_relative './authentification'

module TimetablesOnRails
  class UserAuthentification

    def self.authenticate(user, password)
      Authentification.authenticate user, :password_digest, password
    end
  end
end
