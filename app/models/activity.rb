class Activity < ActiveRecord::Base

  # === DATA ===
  # Type : String, Duration : int, groups : int, teachers : array of users
  attr_accessible :type, :duration, :groups, :teachers

  belongs_to :courses, foreign_key: 'name', class_name: 'Course'

  has_and_belongs_to_many :candidates, class_name: 'User',
                                       join_table: 'candidates_activities',
                                       association_foreign_key: 'candidate_id'

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
    raise ActivityAlreadyAssignedException if assigned?
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
  class ActivityAlreadyAssignedException < StandardError; end

end
