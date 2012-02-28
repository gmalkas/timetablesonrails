require_relative '../spec_helper_lite'
require_relative '../../lib/user_authentification'
require_relative '../../lib/password_hasher'

require 'ostruct'

module TimetablesOnRails
  describe UserAuthentification do
    it "can authenticate a user" do
      username = 'gmalkas'
      password = 'secret'
      password_digest = PasswordHasher.hash password
      user = OpenStruct.new username: username, password_digest: password_digest

      assert UserAuthentification.authenticate user, password
      refute UserAuthentification.authenticate user, 'bad secret' 
    end
  end
end
