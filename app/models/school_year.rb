require 'date'
require_relative './semester'

class SchoolYear
  attr_accessor :start, :end

  def initialize(start_date=Date.new(Time.now.year), end_date=start_date)
    @archived = false
    @activated = false
    @semesters = []
    @start = start_date
    @end = end_date
  end

  def archive!
    @archived = true
  end

  def archived?
    @archived
  end

  def activate!
    @archived = false
    @activated = true
  end

  def disable!
    @activated = false
  end

  def activated?
    @activated
  end

  def semesters
    @semesters
  end

  def new_semester(name, start_date, end_date)
    semester = Semester.new(name, start_date, end_date)
    semester.school_year = self
    @semesters << semester
    semester
  end
end
