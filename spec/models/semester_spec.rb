require_relative '../spec_helper_lite.rb'
require_relative '../../app/models/semester'

describe Semester do
  before do
    @date = Time.now
  end

  subject { Semester.new }

  it "supports reading and writing a starting date" do
    subject.start = @date
    subject.start.must_equal @date
  end

  it "supports reading and writing an ending date" do
    subject.end = @date
    subject.end.must_equal @date
  end

  it "supports reading and writing a name" do
    subject.name = "Semester"
    subject.name.must_equal "Semester"
  end

  it "supports being initialized with attributes" do
    semester = Semester.new("Semester", @date, @date)
    semester.name.must_equal "Semester"
    semester.start.must_equal @date
    semester.end.must_equal @date
  end

  it "supports reading and writing a school year reference" do
    year = stub
    subject.school_year = year
    subject.school_year.must_equal year
  end

end
