require_relative '../spec_helper_lite'
require_relative '../../app/models/user'
require_relative '../../app/models/course'

describe User do
  subject { User.new }

  it "is needs a firstname to be valid" do
    subject.valid?.should be_false
    subject.errors[:firstname].should_not be_empty
  end

  it "needs a lastname to be valid" do
    subject.valid?.should be_false
    subject.errors[:lastname].should_not be_empty
  end

  it "needs a username to be valid" do
    subject.valid?.should be_false
    subject.errors[:username].should_not be_empty
  end

  it "has a unique username" do
    u = User.new username: "gmalkas", firstname: "Gabriel", lastname: "Malkas"
    u.password = "george"
    u.save!

    user = User.new username: "gmalkas", firstname: "George", lastname: "Malkas"
    user.valid?.should be_false
    user.errors[:username].should_not be_empty
  end

  it "has a password" do
    u = User.new username: "gmalkas", firstname: "Gabriel", lastname: "Malkas"
    u.password = "george"
    u.save!

    u.password_digest.should_not be_nil
  end

  describe "#applied?" do
    let(:assembly) { stub }
    let(:java) { stub }

    it "checks wether the user has already applied to a given course" do
      u = User.new username: "gmalkas", firstname: "Gabriel", lastname: "Malkas" 
      u.password = "gabriel"
      u.save

      u.stub(:course_management_applications) { [:java] }

      u.applied?(:java).should be_true
      u.applied?(:assembly).should be_false
    end
  end
  
  describe ".teachers" do
    before do
      [
        { username: "gmalkas", firstname: "Gabriel", lastname: "Malkas" },
        { username: "rlagrange", firstname: "Richard", lastname: "Lagrange" },
        { username: "vguilpain", firstname: "Vincent", lastname: "Guilpain" },
        { username: "alecahain", firstname: "Amandine", lastname: "Le Cahain" }
      ].each do |user_data|
        u = User.new user_data
        u.password = user_data[:username]
        u.administrator = user_data[:username] == "gmalkas"
        u.save!
      end
    end
    
    it "returns the users that are teachers" do
      User.teachers.map(&:username).to_set.should == ["rlagrange", "vguilpain", "alecahain"].to_set
    end
    
    it "orders the user by their lastname" do
      User.teachers.map(&:lastname).should == ["Guilpain", "Lagrange", "Le Cahain"]
    end
  end
end
