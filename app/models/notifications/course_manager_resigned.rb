module Notifications
  class CourseManagerResigned < Notification

    def teacher
      User.find_by_id find_property!('teacher').value
    end

    def course
      Course.find_by_id find_property!('course').value
    end

  end
end

class Notification

  def self.notify_course_manager_resigned(school_year, teacher, course)
    notification = Notifications::CourseManagerResigned.new 
    notification.school_year = school_year

    notification.properties << NotificationProperty.new(name: 'teacher', value: teacher.id, resource: 'user')
    notification.properties << NotificationProperty.new(name: 'course', value: course.id, resource: 'course')

    notification.save!
    notification
  end

end
