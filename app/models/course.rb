class Course < ActiveRecord::Base

  # === DATA ===
  attr_accessible :name

  validates_presence_of :name
  validates :semester_id, presence: true

  belongs_to :semester
  belongs_to :manager, foreign_key: 'manager_id', class_name: 'User'

  # === BEHAVIOR ===
 
  def assigned?
    not self.manager.nil?
  end

  ## Assign a teacher to a course.
  # 
  def assign(user)
    self.manager = user
  end
end
