# encoding: utf-8

require 'date'
require 'singleton'
require_relative './school_year'

##
#
# = SchoolYearManager
# 
# Provides some utility methods to deal with school years. This class is mainly
# there to enforce one constraints : at any time, there can be only one active
# school year.
#
# Clients should avoid using SchoolYear directly and use this class instead.
#
# == Note
#
# The architecture would probably be improved if this class was removed
# and its methods were added directly as class methods of SchoolYear.
#
# This class just adds unnecessary complexity to the whole application.
# The Singleton idea was a bad one.
#
class SchoolYearManager
  include Singleton

  def initialize
    load_school_years
  end

  ##
  #
  # Build a new school year starting at the given date.
  #
  # == Note
  #
  # This methods does not create a database record.
  #
  # == See also
  #
  # SchoolYearManager#new_school_year
  #
  def build_school_year(year=nil)
    return SchoolYear.new if year.blank?

    starting_day = (year.is_a? Date) ? year : start_date_from_year(year)
    SchoolYear.new(start_date: starting_day, end_date: starting_day.next_year)
  end

  ##
  #
  # Saves an instance of SchoolYear to the database.
  #
  def new_school_year(school_year)
    activate_school_year(school_year) if @active.nil?
    @school_years << school_year if school_year.valid?
    school_year.save!
    school_year
  end

  ##
  #
  # Returns an array of school years, sorted according to their starting year.
  #
  def school_years
    load_school_years
    @school_years.sort { |s1, s2| s1.start_date.year <=> s2.start_date.year } 
  end

  ##
  #
  # Removes all school years.
  #
  def clear
    @school_years.clear
    @active = nil
  end

  ##
  #
  # Fetches a school year according to a string id with the following format:
  #
  #   2011-2012
  #
  # See SchoolYear#to_param
  #
  def find!(id)
    SchoolYear.find_by_start_date! start_date_from_year(id.slice 0..3)
  end

  ##
  #
  # Fetches a school year according to its numeric (primary key) id.
  #
  def find_by_id!(id)
    SchoolYear.find_by_id!(id)
  end

  ##
  #
  # Activates the given school year and deactivates all others.
  #
  def activate_school_year(school_year)
    @school_years.each do |s|
      s.disable!
      s.save!
    end
    school_year.activate!
    school_year.save!
    load_school_years
    @active = school_year 
  end

  ##
  #
  # Disables the currently active school year.
  #
  def disable_school_year
    @active.disable!
    @active.save!
  end

  ##
  #
  # Archives the given school year.
  #
  def archive_school_year(school_year)
    school_year.archive!
    school_year.save!
  end

  ##
  #
  # Restores the given school year from archives.
  #
  def restore_school_year(school_year)
    school_year.restore!
    school_year.save!
  end

  ##
  #
  # Destroys the given school year.
  #
  def destroy_school_year(school_year)
    school_year.destroy
    load_school_years
  end

  ##
  #
  # Returns the currently active school year.
  #
  def active_school_year
    load_school_years
    @active 
  end

  private
  
  def load_school_years
    @school_years = SchoolYear.all
    @active = @school_years.select { |s_y| s_y.activated? }.first
  end

  def start_date_from_year(year)
    Date.parse("#{year}-01-01")
  end

end
