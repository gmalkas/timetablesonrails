require_relative '../../spec_helper_lite'
require_relative '../../../lib/timetablesonrails/token'

require 'rr'

module TimetablesOnRails
  describe Token do
    it "generates a Base64 token" do
      stub(SecureRandom).urlsafe_base64 { 'token' } 
      Token.generate.must_equal 'token'
    end
  end
end
