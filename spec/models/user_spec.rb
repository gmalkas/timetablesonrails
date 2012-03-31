require_relative '../spec_helper_lite'
require_relative '../../app/models/user'
require_relative '../../app/models/course'

describe User do

  describe ".build_teacher" do
    it "returns a new user who's not an administrator" do
      teacher = User.build_teacher
      teacher.administrator?.should be_false
    end
  end

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

  it "is not an administrator by default" do
    subject.administrator?.should be_false
  end

  it "is a teacher by default" do
    subject.teacher?.should be_true
  end
  
  describe "#name" do
    it "returns the firstname and the lastname" do
      subject.firstname = "Gabriel"
      subject.lastname = "Malkas"
      subject.name.should == "Malkas Gabriel"
    end
  end

  describe "#teacher?" do
    it "returns true if the user is not an administrator" do
      subject.administrator = true 
      subject.teacher?.should be_false
    end

    it "returns false if the user is not an administrator" do
      subject.administrator = false
      subject.teacher?.should be_true
    end
  end

  describe "#apply_to_course_management" do
    it "adds the user to the candidates list" do
      course = mock(Course)
      course.should_receive(:new_candidate).with(subject)
      subject.apply_to_course_management course
    end
  end

  describe "#withdraw_course_management_application" do
    it "removes the user from the candidates list" do
      course = mock(Course)
      course.should_receive(:dismiss_candidate).with(subject)
      subject.withdraw_course_management_application course
    end
  end

end
