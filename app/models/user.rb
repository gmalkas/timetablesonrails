class User < ActiveRecord::Base
  # === DATA ===
  attr_accessible :username, :firstname, :lastname

  has_secure_password

  has_and_belongs_to_many :course_management_applications, class_name: 'Course', join_table: 'candidates_courses', foreign_key: 'candidate_id'
  has_and_belongs_to_many :activity_applications, class_name: 'Activity',  join_table: 'activities_candidates', foreign_key: 'candidate_id'
  has_and_belongs_to_many :activities, class_name: 'Activity',  join_table: 'activities_teachers', foreign_key: 'teacher_id'
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
  #
  def apply_to_course_management(course)
    course.new_candidate self
  end

  ##
  # Removes the user from the candidates list of the given course.
  #
  def withdraw_course_management_application(course)
    course.dismiss_candidate self
  end

  ##
  # Checks whether the user has already applied to a given course
  #
  def applied?(course)
    course_management_applications.include? course
  end

  ##
  # Checks whether the user is responsible for managing a given course.
  #
  def manage?(course)
    responsabilities.include? course
  end

  def resign_as_manager(course)
    responsabilities.delete course
  end

  def apply_to_activity_teaching(activity)
    self.activity_applications << activity
  end

  def withdraw_activity_teaching_application(activity)
    self.activity_applications.delete activity
  end

  def applied_to_activity_teaching?(activity)
    self.activity_applications.include? activity
  end

  def teaches?(activity)
    self.activities.include? activity
  end

  def resign_as_teacher(activity)
    activities.delete activity
  end

  def self.teachers
    self.where("administrator = ?", false).order("lastname ASC")
  end
end
