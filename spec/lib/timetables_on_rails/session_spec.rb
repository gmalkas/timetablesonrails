require_relative '../../../lib/timetables_on_rails/session'
require_relative '../../../lib/timetables_on_rails/token'

require 'ostruct'

module TimetablesOnRails
  describe Session do

    before do
      @session = mock
      @cookies = mock
      @permanent_cookies = mock
      @cookies.stub!(:permanent) { @permanent_cookies }
      Token.stub!(:generate) { 'token' }
    end

    subject { Session.new :session_token, @session, @cookies }

    it "can create a session" do
      @session.should_receive(:[]=).with(:session_token, 'token')
      subject.create
    end

    it "can create a permanent session" do
      @session.should_receive(:[]=).with(:session_token, 'token')
      @permanent_cookies.should_receive(:[]=).with(:session_token, 'token')
      subject.create_permanent
    end


    describe "when there is an active session" do

      before do
        @session = { session_token: 'token' } 
        @cookies = { session_token: 'token' }
      end

      it "can return the current session token" do
        subject.token.should == 'token'
      end

      it "can return the token from the cookie" do
        @session = { session_token: nil } 

        subject.token.should == 'token'
      end
      
      it "knows there is an active session" do
        subject.active?.should be_true
      end

      it "knows there is a permanent session" do
        subject.permanent?.should be_true
      end

    end

    describe "#destroy" do
      before do
        @session = @cookies = { session_token: 'value' }
      end
     
      it "can destroy a temporary session" do
        subject.destroy
        subject.active?.should be_false
      end

      it "can destroy a permanent session" do
        subject.destroy
        subject.permanent?.should be_false
      end
    end

  end
end
