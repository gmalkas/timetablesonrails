require 'bcrypt'

module TimetablesOnRails
  class PasswordHasher

    def self.hash(password)
      BCrypt::Password.create password
    end

    # Determine whether the given password is correct.
    def self.compare(hash, password)
      BCrypt::Password.new(hash) == password
    end
  end
end
