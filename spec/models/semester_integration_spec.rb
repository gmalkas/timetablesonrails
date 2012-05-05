require_relative '../spec_helper_lite'
require_relative '../../app/models/semester'
require_relative '../../app/models/course'

describe Semester do
  before do
    @date = Time.now
  end

  subject { Semester.new }

  it "needs a name to be valid" do
    subject.valid?.should be_false
    subject.errors[:name].should_not be_empty
  end

  it "needs a starting date to be valid" do
    subject.valid?.should be_false
    subject.errors[:start_date].should_not be_empty
  end

  it "needs an ending date to be valid" do
    subject.valid?.should be_false
    subject.errors[:end_date].should_not be_empty
  end

  it "needs a school year reference to be valid" do
    subject.valid?.should be_false
    subject.errors[:school_year_id].should_not be_empty
  end

  describe "#new_course" do
    subject { FactoryGirl.create :semester }

    it "adds the course to the list" do
      course = subject.new_course "Java"
      course.name.should == "Java"
      subject.courses.last.should == course
    end

    it "sets the semester reference to itself" do
      course = subject.new_course "Java"
      course.semester.should == subject
    end
  end

  describe "#courses" do
    subject { FactoryGirl.create :semester }

    before do
      subject.new_course "Unix"
      subject.new_course "Assembly"
      subject.new_course "C#"
    end

    it "orders the courses by name" do
      subject.courses.map(&:name).should == ["Assembly", "C#", "Unix"]
    end

    it "destroys the courses when destroyed" do
      lambda { subject.destroy }.should change(subject.courses, :count).from(3).to(0)
    end
  end
end
