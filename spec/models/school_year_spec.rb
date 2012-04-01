require_relative '../spec_helper_lite'
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

  it "supports reading and writing a starting year" do
    subject.start_year = "2011"
    subject.start_year.should == "2011"
  end

  it "supports being initialized with attributes" do
    school_year = SchoolYear.new start_date: @date, end_date: @date + 10
    school_year.start_date.should == @date
    school_year.end_date.should == @date + 10
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

  describe "#to_s" do
    it "returns a readable format" do
      school_year = SchoolYear.new start_date: Date.new(2011), end_date: Date.new(2012)
      school_year.to_s.should == "2011 - 2012"
    end
  end

  describe "#to_param" do
    it "returns the starting year" do
      school_year = SchoolYear.new start_date: Date.new(2011), end_date: Date.new(2012)
      school_year.to_param.should == "2011"
    end
  end

end
