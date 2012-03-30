require_relative '../spec_helper_lite.rb'
require_relative '../../app/models/school_year'

describe SchoolYear do
  before do
    @date = Date.new Time.now.year
  end

  subject { SchoolYear.new }

  it "supports reading and writing a starting date" do
    subject.start_date = @date
    subject.start_date.should == @date
  end

  it "supports reading and writing an ending date" do
    subject.end_date = @date
    subject.end_date.should == @date
  end

  it "is not archived when newly created" do
    subject.archived?.should be_false
  end

  it "is not activated when newly created" do
    subject.activated?.should be_false
  end

  it "can be archived" do
    subject.archive!
    subject.archived?.should be_true
  end

  it "can be activated" do
    subject.activate!
    subject.activated?.should be_true
  end

  it "can be disabled" do
    subject.activate!
    subject.activated?.should be_true
    subject.disable!
    subject.activated?.should be_false
  end

  it "is unarchived when activated" do
    subject.archive!
    subject.archived?.should be_true
    subject.activate!
    subject.archived?.should be_false
  end

  it "has semesters" do
    subject.semesters.should be_empty
  end

  it "supports being initialized with attributes" do
    school_year = SchoolYear.new start_date: @date, end_date: @date + 10
    school_year.start_date.should == @date
    school_year.end_date.should == @date + 10
  end

  describe "#add_semester" do

    subject { SchoolYear.create start_date: @date, end_date: @date + 10 }

    it "creates a semester" do
      subject.new_semester "Semester", @date, @date
      semester = subject.semesters.last
      semester.name.should == "Semester"
      semester.start_date.should == @date
      semester.end_date.should == @date
    end

    it "sets the semester's school year reference to itself" do
      subject.new_semester "Semester", @date, @date
      subject.semesters.first.school_year.should == subject
    end

  end

end
