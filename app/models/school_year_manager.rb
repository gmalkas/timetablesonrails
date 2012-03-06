require 'date'
require 'singleton'
require_relative './school_year'

class SchoolYearManager
  include Singleton

  def initialize
    @active = nil
  end

  def new_school_year(year=nil)
    return SchoolYear.new if year.nil?

    starting_day = (year.is_a? Date) ? year : start_date_from_year(year)
    school_year = SchoolYear.new(start_year: starting_day, end_year: starting_day.next_year)
    activate_school_year(school_year) if @school_years.empty?
    @school_years << school_year if school_year.valid?
    school_year
  end

  def school_years
    load_school_years
    @school_years.sort { |s1, s2| s1.start_year.year <=> s2.start_year.year } 
  end

  def clear
    @school_years.clear
  end

  def find!(start_year)
    SchoolYear.find_by_start_year! start_date_from_year(start_year)
  end

  def activate_school_year(school_year)
    @school_years.each do |s|
      s.disable!
      s.save!
    end
    school_year.activate!
    school_year.save!
    @active = school_year 
  end

  def disable_school_year(school_year)
    @active.disable!
    @active.save!
    @active = nil
  end

  def destroy_school_year(school_year)
    school_year.destroy
  end

  def active_school_year
    @active 
  end

  private
  
  def load_school_years
    @school_years = SchoolYear.all
    @active ||= @school_years.select { |s_y| s_y.activated? }.first
  end

  def start_date_from_year(year)
    Date.parse("#{year}-01-01")
  end

end
