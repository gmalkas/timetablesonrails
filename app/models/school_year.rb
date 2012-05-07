require 'date'
require_relative './semester'

class SchoolYear < ActiveRecord::Base

  # === DATA ===
  attr_accessor :start_year
  attr_accessible :start_date, :end_date

  validates :start_date, :end_date, presence: true, uniqueness: true
  
  has_many :semesters, dependent: :destroy
  has_many :courses, through: :semesters
  has_many :notifications, dependent: :destroy, order: 'created_at DESC'

  after_create :create_default_semesters

  # === BEHAVIOR ===

  def archive!
    self.archived = true
    self.disable!
  end

  def restore!
    self.archived = false
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

  def find_semester(id)
    Semester.find_by_id!(id)
  end

  def conflicts
    self.courses.select { |c| c.conflict? }
  end

  def validated_courses
    self.courses.select { |c| c.assigned? }
  end

  def import_from(school_year)
    self.semesters.each do |semester|
      semester.import_from school_year.semesters.find_by_name!(semester.name)
    end
    self.save!
  end

  def to_s
    "#{self.start_date.year} - #{self.end_date.year}"
  end

  def to_param
    "#{self.start_date.year.to_s}-#{self.end_date.year.to_s}"
  end

  protected

  def create_default_semesters
    new_semester "5", Date.new(start_date.year, 9, 14),
                               Date.new(end_date.year, 2, 14)
    new_semester "6", Date.new(end_date.year, 2, 15),
                               Date.new(end_date.year, 6, 15)
    new_semester "7", Date.new(start_date.year, 9, 14),
                               Date.new(end_date.year, 2, 14)
    new_semester "8", Date.new(end_date.year, 2, 15),
                               Date.new(end_date.year, 6, 15)
    new_semester "9", Date.new(start_date.year, 9, 14),
                               Date.new(end_date.year, 2, 14)
    new_semester "10", Date.new(end_date.year, 2, 15),
                               Date.new(end_date.year, 6, 15)
  end
end
