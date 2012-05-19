##
#
# = Notifications::NewCourseCandidate
#
# This notification is created when there is a new candidate
# for a course's management position.
#
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

  def self.notify_new_course_candidate(school_year, teacher, course)
    self.notify Notifications::NewCourseCandidate, school_year do |notification|
      notification.properties << NotificationProperty.new(name: 'teacher', value: teacher.id, resource: 'user')
      notification.properties << NotificationProperty.new(name: 'course', value: course.id, resource: 'course')
      notification.properties << NotificationProperty.new(name: 'candidates', value: course.candidates.size)
      
      # Other candidates need to see this notification, therefore we create these properties
      course.candidates.each do |t|
        notification.properties << NotificationProperty.new(name: "candidate_#{t.id}", value: t.id, resource: 'user') unless t == teacher
      end
    end
  end

end
