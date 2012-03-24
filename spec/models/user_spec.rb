require_relative '../spec_helper_lite.rb'
require_relative '../../app/models/user.rb'

describe User do

  subject { User.new }

  it "supports reading and writing a name" do
    subject.name = "foo"
    subject.name.should == "foo"
  end

  it "supports reading and writing a username" do
    subject.username = "foo"
    subject.username.should == "foo"
  end

  it "supports reading and writing a password digest" do
    subject.password_digest = "foo"
    subject.password_digest.should == "foo"
  end

  it "supports being initialized with attributes" do
    user = User.new name: "John Doe", username: "jdoe"
    user.name.should == "John Doe"
    user.username.should == "jdoe"
  end

end
