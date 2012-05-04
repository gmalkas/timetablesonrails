require_relative './user'
require_relative './activity'

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
    self.candidates.count > 1 
  end

  def new_activity(type, groups, duration)
    self.activities.build type: type, groups: groups, duration: duration
  end
  
  # === Exceptions ===
  class AlreadyAssignedException < StandardError; end

end
