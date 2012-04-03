module Notifications
  class NewCourseCandidate < Notification
    def candidates
     self.properties.select { |p| p.name == 'candidates' }.first.value
    end

    def teacher
      id = self.properties.select { |p| p.name == 'teacher' }.first.value
      User.find_by_id id
    end

    def course
      id = self.properties.select { |p| p.name == 'course' }.first.value
      Course.find_by_id id
    end
  end
end
