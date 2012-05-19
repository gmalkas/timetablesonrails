# encoding: utf-8

require 'date'
require_relative './semester'

##
#
# = SchoolYear
#
# A school year is the main domain model of our
# application : it encapsulates all data related to a specific school year.
#
# A school year is itself pretty simple: it is fully defined by a starting date
# and an ending date.
#
# == States
#
# A school year can be in different states :
#
#   * Active: there can be only one active school year at any time in the
#             application (this constraints is maintained by SchoolYearManager)
#             The active school year is the one everybody should be concerned
#             about, and thus should be easily accessible from the user interface.
#
#   * Archived : an archived shchool year cannot be updated. We don't
#                want teachers to change previous school years for example.
#
#   * Disabled : a disabled school year can be updated. One of the use case of
#                this state is when the administrator wants to work on the next
#                school year even though the current (active) school year
#                is still work in progress.
#
# == Classes
#
# A school year refers to a time period. But the Computer Science Department
# has three different classes, 3rd, 4th and 5th ('class' in this paragraph refers to a level of
# academic development, not to the object-oriented programming concept).
#
# Since we want to be able to deal with courses related to all classes at the
# same time, we need a way to associate a given school year with all classes.
#
# For each class, a school year is composed of two semesters, from early September
# to January for the first one, from January to June for the second one.
#
# Yet, we could not model this fact by associating two semesters to a school year,
# since there would be no way to know which courses belong a given class.
#
# For example, the course "x86 Assembly" is taught to 3rd year students from September
# to late December. We would thus associate it with the "first" semester. But this course
# is irrelevant to 4th and 5th year students. Yet, it would belong to the same 
# semester than other courses relevant only to 4th (or 5th) year students.
#
# Here is how secretaries have dealt with this modeling issue:
#
# A school year is composed of 6 semesters.
# Semesters 5 and 6 are for the 3rd year class, 7 and 8 for the 4th and
# 9 and 10 for the 5th.
#
# It is important to understand that semesters
# 5, 7 and 9 denote the same time period  (as well as semesters 6, 8 and 10).
#
# Hence, semesters 5, 7 and 9 really are the school year's "first" semester,
# but they are associated with different classes.
#
# == See also
#
# SchoolYearManager, Semester
#
class SchoolYear < ActiveRecord::Base

  # === DATA ===
  attr_accessor :start_year
  attr_accessible :start_date, :end_date

  validates :start_date, :end_date, presence: true, uniqueness: true
  
  has_many :semesters, dependent: :destroy
  has_many :courses, through: :semesters
  has_many :notifications, dependent: :destroy, order: 'created_at DESC'

  after_create :create_default_semesters

  # === BEHAVIOR ===
  def archive!
    self.archived = true
    self.disable!
  end

  def restore!
    self.archived = false
  end

  def archived?
    self.archived
  end

  def activate!
    self.archived = false
    self.activated = true
  end

  def disable!
    self.activated = false
  end

  def activated?
    self.activated
  end

  ##
  #
  # Creates a new semester and associates it with the school year.
  #
  def new_semester(name, start_date, end_date)
    semester = Semester.new name: name, start_date: start_date, end_date: end_date
    semester.school_year = self
    self.semesters << semester if semester.valid?
    semester
  end

  def find_semester(id)
    Semester.find_by_id!(id)
  end

  ##
  #
  # Returns courses with conflicts.
  #
  def conflicts
    self.courses.select { |c| c.conflict? }
  end

  ##
  #
  # Returns validated courses (ie. courses assigned to a manager).
  #
  def validated_courses
    self.courses.select { |c| c.assigned? }
  end

  ##
  #
  # Import data from another school year (ie. courses, activities and associations).
  #
  def import_from(school_year)
    self.semesters.each do |semester|
      semester.import_from school_year.semesters.find_by_name!(semester.name)
    end
    self.save!
  end

  ##
  # 
  # == Example
  #
  # 2011 - 2012
  #
  def to_s
    "#{self.start_date.year} - #{self.end_date.year}"
  end

  ##
  #
  # Returns a String representation of the school year to use in URLs.
  # 
  # == Example
  #
  # 2011-2012
  #
  #
  def to_param
    "#{self.start_date.year.to_s}-#{self.end_date.year.to_s}"
  end

  protected

  ##
  #
  # Every school year is composed of 6 semesters. Since there is
  # no point to have a school year without these semesters, we
  # create them as soon as the school year is created.
  #
  def create_default_semesters
    new_semester "5", Date.new(start_date.year, 9, 14),
                               Date.new(end_date.year, 2, 14)
    new_semester "6", Date.new(end_date.year, 2, 15),
                               Date.new(end_date.year, 6, 15)
    new_semester "7", Date.new(start_date.year, 9, 14),
                               Date.new(end_date.year, 2, 14)
    new_semester "8", Date.new(end_date.year, 2, 15),
                               Date.new(end_date.year, 6, 15)
    new_semester "9", Date.new(start_date.year, 9, 14),
                               Date.new(end_date.year, 2, 14)
    new_semester "10", Date.new(end_date.year, 2, 15),
                               Date.new(end_date.year, 6, 15)
  end
end
