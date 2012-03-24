require_relative '../../spec_helper_lite'
require_relative '../../../lib/timetables_on_rails/password_hasher'

require 'bcrypt'

module TimetablesOnRails

  describe PasswordHasher do
    before do
      @password = "secret123"
      @bad_password = "bad"
      @hash = PasswordHasher.hash @password
    end

    it "can hash a password with BCrypt" do
      BCrypt::Password.new(@hash).should == @password 
    end

    it "can compare a given hash with a password" do
      PasswordHasher.compare(@hash, @password ).should be_true
      PasswordHasher.compare(@hash, @bad_password).should be_false
    end

  end
end
