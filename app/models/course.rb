require_relative './user'

class Course < ActiveRecord::Base

  # === DATA ===
  attr_accessible :name

  validates_presence_of :name
  validates :semester_id, presence: true

  belongs_to :semester
  belongs_to :manager, foreign_key: 'manager_id', class_name: 'User'

  has_and_belongs_to_many :candidates, class_name: 'User',
                                       join_table: 'candidates_courses',
                                       association_foreign_key: 'candidate_id'

  # === BEHAVIOR ===
 
  def assigned?
    not self.manager.nil?
  end

  ## 
  # Assign a teacher to a course.
  # Warning: Removes all candidates
  # 
  def assign!(user)
    self.manager = user
    dismiss_candidates
  end

  def new_candidate(user)
    raise CourseAlreadyAssignedException if assigned?
    self.candidates << user
  end

  def dismiss_candidate(candidate)
    self.candidates.delete candidate
  end

  def dismiss_candidates
    self.candidates.clear
  end

  def conflict?
    self.candidates.count > 1 
  end
  
  # === Exceptions ===
  class CourseAlreadyAssignedException < StandardError; end

end
