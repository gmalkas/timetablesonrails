require_relative '../../spec_helper_lite'
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

      assert Authentification.authenticate resource, :password_hash, password
      refute Authentification.authenticate resource, :password_hash, bad_password
    end
    
  end
end
