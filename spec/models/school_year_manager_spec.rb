require_relative '../spec_helper_lite.rb'
require_relative '../../app/models/school_year_manager.rb'

describe SchoolYearManager do

  before do
    SchoolYearManager.instance.clear
  end

  describe "#build_school_year" do

    it "can build an empty school year" do
      school_year = SchoolYearManager.instance.build_school_year
      school_year.should be_new_record
    end
    
    it "can build a school year with a String" do
      school_year = SchoolYearManager.instance.build_school_year "2012"
      school_year.start_date.year.should == 2012
      school_year.end_date.year.should == 2013
    end

    it "can build a school year with a Date" do
      date = Date.new(2012, 8, 24)
      school_year = SchoolYearManager.instance.build_school_year date
      school_year.start_date.should == date
      school_year.end_date.should == date.next_year
    end

  end

  describe "#new_school_year" do

    it "activates the school year if it is the first one created" do
      school_year = SchoolYearManager.instance.build_school_year "2012"
      school_year = SchoolYearManager.instance.new_school_year school_year
      school_year.activated?.should be_true
    end

    it "doesn't activate the school year if there were already school years" do
      school_year_one = SchoolYearManager.instance.build_school_year "2012"
      school_year_one = SchoolYearManager.instance.new_school_year school_year_one
      school_year_two = SchoolYearManager.instance.build_school_year "2013"
      school_year_two = SchoolYearManager.instance.new_school_year school_year_two
      school_year_two.activated?.should be_false
    end

    it "adds the school year to the school years list" do
      school_year = SchoolYearManager.instance.build_school_year "2012"
      school_year = SchoolYearManager.instance.new_school_year school_year
      SchoolYearManager.instance.school_years.should include(school_year)
    end
  end

  describe "#school_years" do
    it "returns existing school years ordered by starting date" do
      year_one = SchoolYearManager.instance.build_school_year 2011
      year_one = SchoolYearManager.instance.new_school_year year_one
      year_three = SchoolYearManager.instance.build_school_year 2013
      year_three = SchoolYearManager.instance.new_school_year year_three
      year_two = SchoolYearManager.instance.build_school_year 2012
      year_two = SchoolYearManager.instance.new_school_year year_two
      SchoolYearManager.instance.school_years.should == [year_one, year_two, year_three]
    end
  end

  describe "#active_school_year" do
    it "returns the active school year" do
      year_one = SchoolYearManager.instance.build_school_year 2011
      year_one = SchoolYearManager.instance.new_school_year year_one
      SchoolYearManager.instance.active_school_year.should == year_one
    end
  end

  describe "#activate_school_year" do
    it "deactivates all school years except one" do
      year_one = SchoolYearManager.instance.build_school_year 2011
      year_one = SchoolYearManager.instance.new_school_year year_one
      year_two = SchoolYearManager.instance.build_school_year 2012
      year_two = SchoolYearManager.instance.new_school_year year_two
      SchoolYearManager.instance.activate_school_year year_two
      year_two.activated?.should be_true
      year_one.activated?.should be_false
    end
  end

  describe "#disable_school_year" do
    it "disables the active school year" do
      year_one = SchoolYearManager.instance.build_school_year 2011
      year_one = SchoolYearManager.instance.new_school_year year_one
      SchoolYearManager.instance.disable_school_year
      year_one.activated?.should be_false
      SchoolYearManager.instance.active_school_year.should be_nil
    end
  end

end
