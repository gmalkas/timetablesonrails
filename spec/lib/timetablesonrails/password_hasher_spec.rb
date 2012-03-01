require_relative '../../spec_helper_lite'
require_relative '../../../lib/timetablesonrails/password_hasher'

require 'bcrypt'

module TimetablesOnRails

  describe PasswordHasher do
    before do
      @password = "secret123"
      @bad_password = "bad"
      @hash = PasswordHasher.hash @password
    end

    it "can hash a password with BCrypt" do
      assert BCrypt::Password.new(@hash) == @password 
    end

    it "can compare a given hash with a password" do
      assert PasswordHasher.compare @hash, @password 
      refute PasswordHasher.compare @hash, @bad_password
    end

  end
end
