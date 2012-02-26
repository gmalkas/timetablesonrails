require_relative '../spec_helper_lite.rb'
require_relative '../../app/models/school_year'

describe SchoolYear do
  before do
    @date = Time.now
  end

  subject { SchoolYear.new }

  it "supports reading and writing a starting date" do
    subject.start = @date
    subject.start.must_equal @date
  end

  it "supports reading and writing an ending date" do
    subject.end = @date
    subject.end.must_equal @date
  end

  it "is not archived when newly created" do
    refute subject.archived? 
  end

  it "is not activated when newly created" do
    refute subject.activated?
  end

  it "can be archived" do
    subject.archive!
    assert subject.archived?
  end

  it "can be activated" do
    subject.activate!
    assert subject.activated?
  end

  it "can be disabled" do
    subject.activate!
    assert subject.activated?
    subject.disable!
    refute subject.activated?
  end

  it "is unarchived when activated" do
    subject.archive!
    assert subject.archived?
    subject.activate!
    refute subject.archived?
  end

  it "has semesters" do
    subject.semesters.must_be_empty 
  end

  it "supports being initialized with attributes" do
    school_year = SchoolYear.new(@date, @date + 10)
    school_year.start.must_equal @date
    school_year.end.must_equal @date + 10
  end

  describe "#add_semester" do

    it "creates a semester" do
      subject.new_semester "Semester", @date, @date
      semester = subject.semesters.first
      semester.name.must_equal "Semester"
      semester.start.must_equal @date
      semester.end.must_equal @date
    end

    it "sets the semester's school year reference to itself" do
      subject.new_semester "Semester", @date, @date
      subject.semesters.first.school_year.must_equal subject
    end

  end

end
