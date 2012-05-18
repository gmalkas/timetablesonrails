##
#
# = CoursePresenter
#
# Decorates Course to encapsulate the knowledge associated
# with course rendering.
#
class CoursePresenter
  attr_accessor :course

  def initialize(course)
    @course = course
  end

  ##
  #
  # Renders a course partial according to the course's state
  # (assigned to a manager or not).
  #
  def render(context)
    if @course.assigned?
      context.render 'courses/assigned_course', course: course
    else
      context.render course
    end
  end

end
