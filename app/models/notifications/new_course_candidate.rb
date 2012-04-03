module Notifications
  class NewCourseCandidate < Notification
    def candidates
      find_property! 'candidates'
    end

    def teacher
      User.find_by_id find_property!('teacher')
    end

    def course
      Course.find_by_id find_property!('course')
    end
  end
end
