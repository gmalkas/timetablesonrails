# encoding: utf-8

require_relative './user'
require_relative './activity'

##
#
# = Course
#
# A course models what secretaries call a "élément constitutif", it is
# equivalent to university courses.
#
# Examples of courses are "x86 Assembly", "Data structures", "Java".
#
# A course is composed of at most 4 different activities: "lectures" (Cours magistral),
# "tutoring" (T.P), "exercises" (T.D), "projects".
#
# The name "Course" might not be the best pick since "T.D" is sometimes translated to "course".
# What we refer as a course might in fact be a "module", but we'll stick to course.
#
# == States
#
# A course can be in different states:
#
#   * Waiting ("en attente"): the course has been created, but has no manager. It might have
#     one candidate but she has not yet been accepted as manager.
#
#   * Conflict ("En conflit"): the course has no manager but there are more than one candidate
#     for the management position. There is therefore a conflict that needs to be dealt with.
#
#   * Assigned ("Avec responsable"): the course has been assigned to a teacher (who's thus the course's manager).
#
# == See also
#
# Semester, Activity
#
class Course < ActiveRecord::Base

  # === DATA ===
  attr_accessible :name

  validates :name, :semester_id, presence: true

  belongs_to :semester
  belongs_to :manager, foreign_key: 'manager_id', class_name: 'User'

  has_and_belongs_to_many :candidates, class_name: 'User',
                                       join_table: 'candidates_courses',
                                       association_foreign_key: 'candidate_id'

  has_many :activities, dependent: :destroy, order: 'type ASC'

  Filters = [ { name: 'Semestre', filter: 'semester' }, { name: 'Statut', filter: 'status' }, { name: 'Responsable', filter: 'manager' } ]
  DefaultFilter = Filters.first

  # === BEHAVIOR ===
 
  def assigned?
    not self.manager.nil?
  end

  ## 
  #
  # Assigns a teacher to a course. The teacher thus
  # becomes the course's manager.
  #
  # == Warning 
  #
  # Removes all candidates
  # 
  def assign!(user)
    self.manager = user
    dismiss_candidates
  end

  def new_candidate(user)
    raise AlreadyAssignedException if assigned?
    self.candidates << user
  end

  def find_candidate(id)
    self.candidates.find id
  end

  def dismiss_candidate(candidate)
    self.candidates.delete candidate
  end

  def dismiss_candidates
    self.candidates.clear
  end

  ##
  #
  # Checks whether or not there is a conflict for the course's management position.
  # If there are more than one candidate, there is a conflict (since there can be only one manager).
  #
  def conflict?
    self.candidates.count > 1 
  end

  def status
    case
    when conflict?
      'En conflit'
    when assigned?
      'Avec responsable'
    else
      'En attente'
    end
  end

  ##
  #
  # Builds a new activity for the course (the activity will not be created right away).
  #
  def new_activity(type, groups, duration)
    self.activities.build type: type, groups: groups, duration: duration
  end

  ##
  #
  # Import data (activities and their respective teachers) from another course.
  #
  def import_from(course)
    self.manager = course.manager

    course.activities.each do |activity|
      new_activity = activity.dup
      activity.teachers.each do |teacher|
        new_activity.teachers << teacher
      end
      new_activity.course = self
      new_activity.save!
    end
  end
  
  # === Exceptions ===
  class AlreadyAssignedException < StandardError; end

end
