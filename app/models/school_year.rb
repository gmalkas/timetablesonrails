require 'date'
require_relative './semester'

class SchoolYear < ActiveRecord::Base

  # === DATA ===
  attr_accessible :start_year, :end_year, :archived, :activated

  validates :start_year, :end_year, presence: true, uniqueness: true
  
  has_many :semesters, dependent: :destroy

  after_create :create_default_semesters

  # === BEHAVIOR ===

  def archive!
    self.archived = true
    self.disable!
  end

  def archived?
    self.archived
  end

  def activate!
    self.archived = false
    self.activated = true
  end

  def disable!
    self.activated = false
  end

  def activated?
    self.activated
  end

  def new_semester(name, start_date, end_date)
    semester = Semester.new name: name, start_date: start_date, end_date: end_date
    semester.school_year = self
    self.semesters << semester if semester.valid?
    semester
  end

  protected

  def create_default_semesters
    new_semester "Semestre 5", Date.new(start_year.year, 9, 14),
                               Date.new(end_year.year, 2, 14)
    new_semester "Semestre 6", Date.new(end_year.year, 2, 15),
                               Date.new(end_year.year, 6, 15)
  end
end
