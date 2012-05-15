class CourseListPresenter
  attr_reader :filter, :semesters, :courses

  def initialize(semesters, courses, filter)
    @semesters = semesters
    @courses = courses
    # Makes sure the filter is one that is defined in the Course model
    @filter = (Course::Filters.map { |f| f[:filter] }.include? filter) ? filter : Course::DefaultFilter[:filter]
  end

  def render(context)
    context.render "courses/course_list_filtered_by_#{@filter}",  semesters: @semesters, indexes: @courses
  end
end
