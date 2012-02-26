class Semester
  attr_accessor :name, :start, :end, :school_year

  def initialize(name="", start_date=Time.now, end_date=Time.now)
    @name = name
    @start = start_date
    @end = end_date
  end
end
