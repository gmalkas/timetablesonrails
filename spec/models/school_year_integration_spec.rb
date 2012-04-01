require_relative '../spec_helper_lite'
require_relative '../../app/models/school_year'

require 'ostruct'

describe SchoolYear do
  before do
    @date = Date.new Time.now.year
  end

  subject { SchoolYear.new }

  it "needs a starting date to be valid" do
    subject.valid?.should be_false
    subject.errors[:start_date].should_not be_empty
  end

  it "needs an ending date to be valid" do
    subject.valid?.should be_false
    subject.errors[:end_date].should_not be_empty
  end

  context "with an existing school year" do
    before do
      SchoolYear.create! start_date: @date, end_date: @date.next_year
    end

    subject { school_year = SchoolYear.new start_date: @date, end_date: @date.next_year }

    it "needs a unique starting date to be valid" do
      subject.valid?.should be_false
      subject.errors[:start_date].should_not be_empty
    end

    it "needs a unique ending date" do
      subject.valid?.should be_false
      subject.errors[:start_date].should_not be_empty
    end
  end

  it "creates default semesters when created" do
    school_year = SchoolYear.create start_date: @date, end_date: @date.next_year 
    school_year.semesters.map(&:name).should == ["5", "6", "7", "8", "9", "10"]
  end

  it "has semesters" do
    subject.semesters.should be_empty
  end

  context "with courses" do
    subject { SchoolYear.create start_date: @date, end_date: @date.next_year }

    before do
      courses = []
      1.upto(4) do |i|
        courses << OpenStruct.new(conflict?: i % 2 == 0, name: i, assigned?: i % 2 == 1)
      end

      subject.stub(:courses) { courses }
    end

    describe "#conflicts" do
      it "returns only courses with an ongoing conflict" do
        subject.conflicts.map(&:name).should == [2, 4]
      end
    end

    describe "#validated_courses" do
      it "returns only courses assigned to a manager" do
        subject.validated_courses.map(&:name).should == [1, 3]
      end
    end
  end

  describe "#new_semester" do

    subject { SchoolYear.create start_date: @date, end_date: @date + 10 }

    it "creates a semester and adds it to the list" do
      subject.new_semester "Semester", @date, @date
      semester = subject.semesters.last
      semester.name.should == "Semester"
      semester.start_date.should == @date
      semester.end_date.should == @date
    end

    it "does not add the semester if it is invalid" do
      semester = subject.new_semester "Semester", nil, @date
      subject.semesters.should_not include(semester)
    end

    it "sets the semester's school year reference to itself" do
      subject.new_semester "Semester", @date, @date
      subject.semesters.first.school_year.should == subject
    end

  end

end
