require_relative '../spec_helper_lite.rb'
require_relative '../../app/models/school_year_manager.rb'

describe SchoolYearManager.instance do

  before do
    SchoolYearManager.instance.clear
  end
  
  describe "#new_school_year" do

    before do
      @year = Time.now.year
    end

    it "can create a school year with a String year" do
      school_year = SchoolYearManager.instance.new_school_year("2012")
      school_year.start.year.must_equal 2012
      school_year.end.year.must_equal 2013
    end

    it "can create a school year with an integer year" do
      school_year = SchoolYearManager.instance.new_school_year(@year)
      school_year.start.year.must_equal @year
      school_year.end.year.must_equal @year + 1
    end

    it "can create a school year with a Date" do
      date = Date.new(2012, 8, 24)
      school_year = SchoolYearManager.instance.new_school_year(date)
      school_year.start.must_equal date
      school_year.end.must_equal date.next_year
    end

    it "activates the school year if it is the first one created" do
      school_year = SchoolYearManager.instance.new_school_year("2012")
      assert school_year.activated?
    end

    it "doesn't activate the school year if there were already school years" do
      school_year_one = SchoolYearManager.instance.new_school_year("2012")
      school_year_two = SchoolYearManager.instance.new_school_year("2013")
      refute school_year_two.activated?
    end
  end

  describe "#school_years" do
     
    it "returns existing school years ordered by starting date" do
      year_one = SchoolYearManager.instance.new_school_year 2011
      year_three = SchoolYearManager.instance.new_school_year 2013
      year_two = SchoolYearManager.instance.new_school_year 2012
      SchoolYearManager.instance.school_years.must_equal [year_one, year_two, year_three]
    end

  end

  describe "#active_school_year" do
    it "returns the active school year" do
      year_one = SchoolYearManager.instance.new_school_year 2011
      SchoolYearManager.instance.active_school_year.must_equal year_one
    end
  end

  describe "#activate_school_year" do
    it "deactivates all school years except one" do
      year_one = SchoolYearManager.instance.new_school_year 2011
      year_two = SchoolYearManager.instance.new_school_year 2012
      SchoolYearManager.instance.activate_school_year year_two
      assert year_two.activated?
      refute year_one.activated?
    end
  end


end
