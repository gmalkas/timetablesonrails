require_relative './course'

class Semester < ActiveRecord::Base

  # === DATA ===
  attr_accessible :name, :start_date, :end_date

  validates_presence_of :name, :start_date, :end_date
  validates :school_year_id, presence: true

  belongs_to :school_year
  has_many :courses, order: 'name ASC', dependent: :destroy

  # === BEHAVIOR ===
  
  def new_course(name)
    self.courses.create name: name
  end

  def find_course(id)
    self.courses.find id
  end

end
