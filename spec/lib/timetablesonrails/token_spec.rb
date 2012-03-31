require_relative '../../../lib/timetables_on_rails/token'

module TimetablesOnRails
  describe Token do
    it "generates a Base64 token" do
      SecureRandom.stub!(:urlsafe_base64) { 'token' }
      Token.generate.should == 'token'
    end
  end
end
