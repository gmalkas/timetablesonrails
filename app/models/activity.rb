# encoding: utf-8

##
#
# = Activity
#
# An activity models a concrete school activity, such as a lecture or a tutoring session.
#
# Each activity can have many groups (e.g a lecture would have only one group since the whole class
# attend to the same lecture, but the class is divided into 4 smaller groups for tutoring sessions).
#
# Each activity has a duration (expressed in hours). It is important to understand that this
# duration does not express the duration of a single instance of the activity
# (e.g 2 hours per week) but the total duration of the activity in a semester.
#
# Hence, if there were 12 lectures of 2 hours each, the activity's duration
# would be 24.
#
# == Teachers
#
# An activity has one or many teachers. The number of teachers is exactly the number
# of groups: if there is only one group, we only need one teachers. But if the class
# is divided in many groups, we need a teacher for each group. A teacher could be
# responsible for more than one group in some cases (another teacher is sick), therefore
# we should not enforce a one-to-one association between teachers and activities.
#
# == Types
#
# There are four types of activities:
#
#   * lecture ('Cours')
#   
#   * tutoring ('TP')
#
#   * exercices ('TD')
#
#   * projects ('Projets')
#
# == States
#
# An activity can be in different states:
#
#   * Waiting ('en attente'): there are candidates but not enough to create a conflict.
#
#   * Conflict ('En conflit'): there are more candidates than available teaching positions.
#     The course's manager or the administrator will have therefore a choice to make.
#
#   * Assigned ('Avec enseignants'): there is just the right number of teachers, the activity
#     should therefore not be open for other candidates.
#
# == See also
#
# Course
#
class Activity < ActiveRecord::Base

  # === DATA ===
  attr_accessible :type, :duration, :groups

  belongs_to :course

  has_and_belongs_to_many :candidates, class_name: 'User',
                                       join_table: 'activities_candidates',
                                       association_foreign_key: 'candidate_id'

  has_and_belongs_to_many :teachers, class_name: 'User',
                                     join_table: 'activities_teachers',
                                     association_foreign_key: 'teacher_id'

  validates_presence_of :course_id, :type, :duration, :groups
  validates :groups, numericality: true
  validates :type, inclusion: { in: %w(TP TD Cours Projet), message: "%{value} n'est pas un type d'activité correct."}

  ##
  #
  # We need to override this method since we have a 'type' column that is not used
  # to implement a single table inheritance.
  #
  def self.inheritance_column
    ''
  end

  # === BEHAVIOR ===
  def assigned?
    self.teachers.count == self.groups
  end

  ## 
  # Assign a candidate to an activity.
  # Warning: Removes all candidates
  # 
  def assign!(candidate)
    self.teachers << candidate
    dismiss_candidate candidate
    if self.teachers.count == self.groups
    	dismiss_candidates
    end
  end

  def new_candidate(user)
    raise AlreadyAssignedException if assigned?
    self.candidates << user
  end

  def dismiss_candidate(candidate)
    self.candidates.delete candidate
  end

  def dismiss_candidates
    self.candidates.clear
  end

  def dismiss_teacher(teacher)
    self.teachers.delete teacher
  end

  ##
  #
  # An activity has a conflict when there are more candidates than groups.
  #
  def conflict?
    self.candidates.count > self.groups
  end
  
  # === Exceptions ===
  class AlreadyAssignedException < StandardError; end

end
