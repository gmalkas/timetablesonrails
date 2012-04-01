require_relative '../spec_helper_lite'
require_relative '../../app/models/course'
require_relative '../../app/models/user'

describe Course do

  subject { Course.new }

  it "supports reading and writing a name" do
    subject.name = "course"
    subject.name.should == "course"
  end

  it "supports reading and writing a semester reference" do
    subject.semester_id = 1
    subject.semester_id.should == 1
  end

  it "supports reading and writing a manager reference" do
    subject.manager_id = 1
    subject.manager_id.should == 1
  end

  it "supports being initialized with attributes" do
    course = Course.new name: "Ruby"
    course.name.should == "Ruby"
  end

  describe "conflict?" do
    it "returns true if there are too many candidates" do
      subject.stub(:candidates) { [1, 2] }
      subject.conflict?.should be_true
    end

    it "returns false if there is less than one candidate" do
      subject.stub(:candidates) { [] }
      subject.conflict?.should be_false
    end
  end

  describe "assigned?" do
    it "is not assigned by default" do
      subject.assigned?.should be_false
    end
    
    it "returns true only if the course is assigned to a manager" do
      subject.manager = User.new
      subject.assigned?.should be_true
    end
  end
end
