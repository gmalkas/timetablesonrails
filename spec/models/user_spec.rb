require_relative '../spec_helper_lite.rb'
require_relative '../../app/models/user.rb'

describe User do

  subject { User.new }

  it "supports reading and writing a name" do
    subject.name = "foo"
    subject.name.must_equal "foo"
  end

  it "supports reading and writing a username" do
    subject.username = "foo"
    subject.username.must_equal "foo"
  end

  it "supports reading and writing a password digest" do
    subject.password_digest = "foo"
    subject.password_digest.must_equal "foo"
  end

  it "supports being initialized with attributes" do
    user = User.new name: "John Doe", username: "jdoe",
                    password_digest: "secret"
    user.name.must_equal "John Doe"
    user.username.must_equal "jdoe"
    user.password_digest.must_equal "secret"
  end

end
