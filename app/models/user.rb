class User < ActiveRecord::Base
  # === DATA ===
  attr_accessible :username, :firstname, :lastname

  has_secure_password

  has_and_belongs_to_many :courses, join_table: 'candidates_courses', foreign_key: 'candidate_id'
  has_many :responsabilities, class_name: 'Course', foreign_key: 'manager_id', dependent: :nullify

  validates_presence_of :firstname, :lastname, :username
  validates_uniqueness_of :username

  def name
   self.lastname + " " + self.firstname
  end

  def self.build_teacher
    u = self.new
  end

  def teacher?
    not administrator?
  end

  # === BEHAVIOR ===
  
  ##
  # Adds the user to the candidates list of the given course.
  def apply_to_course_management(course)
    course.new_candidate self
  end

  ##
  # Removes the user from the candidates list of the given course.
  def withdraw_course_management_application(course)
    course.dismiss_candidate self
  end

  ##
  # Checks whether the user has already applied to a given course
  def applied?(course)
    courses.include? course
  end

  def self.teachers
    self.where("administrator = ?", false).order("lastname ASC")
  end
end
