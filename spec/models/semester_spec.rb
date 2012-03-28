require_relative '../spec_helper_lite.rb'
require_relative '../../app/models/school_year'
require_relative '../../app/models/semester'

describe Semester do
  before do
    @date = Time.now
  end

  subject { Semester.new }

  it "supports reading and writing a starting date" do
    subject.start_date = @date
    subject.start_date.should == @date
  end

  it "supports reading and writing an ending date" do
    subject.end_date = @date
    subject.end_date.should == @date
  end

  it "supports reading and writing a name" do
    subject.name = "Semester"
    subject.name.should == "Semester"
  end

  it "supports being initialized with attributes" do
    semester = Semester.new name: "Semester", start_date: @date, end_date: @date
    semester.name.should == "Semester"
    semester.start_date.should == @date
    semester.end_date.should == @date
  end

  it "supports reading and writing a school year reference" do
    year = SchoolYear.new
    subject.school_year = year
    subject.school_year.should == year
  end

end
