class CoursePresenter
  attr_accessor :course

  def initialize(course)
    @course = course
  end

  def render(context)
    if @course.assigned?
      context.render 'courses/assigned_course', course: course
    else
      context.render course
    end
  end

end
