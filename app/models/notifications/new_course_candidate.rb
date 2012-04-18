module Notifications
  class NewCourseCandidate < Notification

    before_create :build_style

    def candidates
      find_property!('candidates').value
    end

    def teacher
      User.find_by_id find_property!('teacher').value
    end

    def course
      Course.find_by_id find_property!('course').value
    end

    protected

    def build_style
      self.style = (candidates > 1) ? 'error' : ''
    end
  end
end

class Notification

  def self.notify_new_course_candidate(teacher, course)
    notification = Notifications::NewCourseCandidate.new 
    notification.properties << NotificationProperty.new(name: 'teacher', value: teacher.id, resource: 'user')
    notification.properties << NotificationProperty.new(name: 'course', value: course.id, resource: 'course')
    notification.properties << NotificationProperty.new(name: 'candidates', value: course.candidates.size)
    notification.save!
    notification
  end

end
