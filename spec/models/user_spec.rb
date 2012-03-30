require_relative '../spec_helper_lite.rb'
require_relative '../../app/models/user.rb'

describe User do

  subject { User.new }

  it "supports reading and writing a firstname" do
    subject.firstname = "foo"
    subject.firstname.should == "foo"
  end
  
  it "supports reading and writing a lastname" do
    subject.lastname = "foo"
    subject.lastname.should == "foo"
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
    user = User.new firstname: "John", lastname: "Doe", username: "jdoe"
    user.firstname.should == "John"
    user.lastname.should == "Doe"
    user.username.should == "jdoe"
  end

end
