require_relative '../../../lib/timetables_on_rails/user_authentification'
require_relative '../../../lib/timetables_on_rails/password_hasher'

require 'ostruct'

module TimetablesOnRails
  describe UserAuthentification do
    it "can authenticate a user" do
      username = 'gmalkas'
      password = 'secret'
      password_digest = PasswordHasher.hash password
      user = OpenStruct.new username: username, password_digest: password_digest

      UserAuthentification.authenticate(user, password).should be_true
      UserAuthentification.authenticate(user, 'bad secret').should be_false
    end
  end
end
