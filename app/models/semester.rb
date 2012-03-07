class Semester < ActiveRecord::Base

  # === DATA ===
  attr_accessible :name, :start_date, :end_date

  validates_presence_of :name, :start_date, :end_date
  validates :school_year_id, presence: true

  belongs_to :school_year
  has_many :courses

  # === BEHAVIOR ===
  
  def new_course(name)
    course = Course.new name: name
    course.semester = self
    self.courses << course if course.valid?
    course
  end

  def courses
    super.sort { |c1, c2| c1.name <=> c2.name }
  end

end
