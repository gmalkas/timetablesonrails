require_relative '../../../lib/timetables_on_rails/authentification'
require_relative '../../../lib/timetables_on_rails/password_hasher'

require 'ostruct'

module TimetablesOnRails
  describe Authentification do

    it "can authentificate a resource with a login and a password" do
      password = 'littlebee'
      bad_password = 'bigbee'
      password_hash = PasswordHasher.hash password
      resource = OpenStruct.new password_hash: password_hash

      Authentification.authenticate(resource, :password_hash, password).should be_true
      Authentification.authenticate(resource, :password_hash, bad_password).should be_false
    end
    
  end
end
