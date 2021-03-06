##
#
# = CourseObserver
#
# Destroys notifications related to a newly destroyed course.
#
class CourseObserver < ActiveRecord::Observer

  def after_destroy(course)
    Notification.related_to(course).destroy_all  
  end
end
