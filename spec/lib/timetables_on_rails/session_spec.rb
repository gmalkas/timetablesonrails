require_relative '../../spec_helper_lite'
require_relative '../../../lib/timetables_on_rails/session'
require_relative '../../../lib/timetables_on_rails/token'

require 'ostruct'

module TimetablesOnRails
  describe Session do

    before do
      @session = MiniTest::Mock.new
      @cookies = MiniTest::Mock.new
      @permanent_cookies = MiniTest::Mock.new
      stub(@cookies).permanent { @permanent_cookies }
      stub(Token).generate { 'token' }
    end

    subject { Session.new :session_token, @session, @cookies }

    it "can create a session" do
      @session.expect(:[]=, nil, [:session_token, 'token'])
      subject.create
      assert @session.verify
    end

    it "can create a permanent session" do
      @session.expect(:[]=, nil, [:session_token, 'token'])
      @permanent_cookies.expect(:[]=, nil, [:session_token, 'token'])
      subject.create_permanent
      assert @session.verify
      assert @permanent_cookies.verify
    end


    describe "when there is an active session" do

      before do
        @session = { session_token: 'token' } 
        @cookies = { session_token: 'token' }
      end

      it "can return the current session token" do
        subject.token.must_equal 'token'
      end

      it "can return the token from the cookie" do
        @session = { session_token: nil } 

        subject.token.must_equal 'token'
      end
      
      it "knows there is an active session" do
        assert subject.active?
      end

      it "knows there is a permanent session" do
        assert subject.permanent?
      end

    end

    describe "#destroy" do
      before do
        @session = @cookies = { session_token: 'value' }
      end
     
      it "can destroy a temporary session" do
        subject.destroy
        refute subject.active?
      end

      it "can destroy a permanent session" do
        subject.destroy
        refute subject.permanent?
      end
    end

  end
end
