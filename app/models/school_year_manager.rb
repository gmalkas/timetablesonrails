require 'date'
require 'singleton'
require_relative './school_year'

class SchoolYearManager
  include Singleton

  def initialize
    @school_years = []
    @active = nil
  end

  def new_school_year(year)
    starting_day = (year.is_a? Date) ? year : Date.parse("#{year}-01-01")
    school_year = SchoolYear.new(starting_day, starting_day.next_year)
    activate_school_year(school_year) if @school_years.empty?
    @school_years << school_year
    school_year
  end

  def school_years
   @school_years.sort { |s1, s2| s1.start.year <=> s2.start.year } 
  end

  def clear
    @school_years.clear
  end

  def activate_school_year(school_year)
    @school_years.each { |s| s.disable! }
    school_year.activate!
    @active = school_year 
  end

  def active_school_year
    @active 
  end

end
