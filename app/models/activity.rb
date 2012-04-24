# encoding: utf-8
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

  def conflict?
    self.candidates.count > self.groups
  end
  
  # === Exceptions ===
  class AlreadyAssignedException < StandardError; end

end
