require 'cancan'
require 'cancan/matchers'

require_relative '../spec_helper_lite'
require_relative '../../app/models/ability'

describe User do
  describe "abilities" do
    subject { ability }
    let(:ability) { Ability.new user }

    context "when is a guest" do
      let(:user) { User.new }

      it "cannot do anything" do
        ability.should_not be_able_to :manage, :all
      end
    end

    context "when is a teacher" do
      let(:user) {
        FactoryGirl.create :user
      }

      it "can read courses" do
        ability.should be_able_to :read, Course.new
      end

      it "can apply and withdraw from courses management" do
        ability.should be_able_to :apply, Course.new
        ability.should be_able_to :withdraw, Course.new
      end

      it "cannot manage courses" do
        ability.should_not be_able_to :update, Course.new
        ability.should_not be_able_to :destroy, Course.new
      end
    end

    context "when is an administrator" do
      let(:user) {
        FactoryGirl.create :administrator
      }

      it "can do almost everything" do
        ability.should be_able_to :manage, :all
      end

      it "cannot apply nor withdraw from courses management" do
        ability.should_not be_able_to :apply, Course.new
        ability.should_not be_able_to :withdraw, Course.new
      end
    end
    
  end
end
