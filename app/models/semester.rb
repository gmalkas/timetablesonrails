require_relative './course'

##
#
# = Semester
#
# A semester models a time period of roughly 6 months
# (there is no constraints to enforce this fact though).
#
# == Note
#
# It is crucial to understand that each school year has
# 6 semesters, since we have three academic levels to deal with.
#
# See SchoolYear to learn more about the relationship between
# school years and semesters.
#
# == See also
#
# School Year, Course
#
class Semester < ActiveRecord::Base

  # === DATA ===
  attr_accessible :name, :start_date, :end_date

  validates_presence_of :name, :start_date, :end_date, :school_year_id

  belongs_to :school_year
  has_many :courses, order: 'name ASC', dependent: :destroy

  # === BEHAVIOR ===
  
  def new_course(name)
    self.courses.build name: name
  end

  def find_course(id)
    self.courses.find id
  end

  def import_from(semester)
    semester.courses.each do |course|
      new_course = self.courses.create name: course.name
      new_course.import_from course
      new_course.save!
    end
  end

end
