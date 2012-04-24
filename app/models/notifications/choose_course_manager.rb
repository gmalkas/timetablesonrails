module Notifications
  class ChooseCourseManager < Notification

    def administrator
      User.find_by_id find_property!('administrator').value
    end

    def teacher
      User.find_by_id find_property!('teacher').value
    end

    def course
      Course.find_by_id find_property!('course').value
    end

  end
end

class Notification

  def self.notify_course_manager_chosen(school_year, administrator, teacher, course)
    notification = Notifications::ChooseCourseManager.new 
    notification.school_year = school_year
    notification.style = 'success'
    notification.properties << NotificationProperty.new(name: 'administrator', value: administrator.id, resource: 'user')
    notification.properties << NotificationProperty.new(name: 'teacher', value: teacher.id, resource: 'user')
    notification.properties << NotificationProperty.new(name: 'course', value: course.id, resource: 'course')
    
    # Other candidates need to see this notification, therefore we create these properties
    course.candidates.each do |t|
      notification.properties << NotificationProperty.new(name: "candidate_#{t.id}", value: t.id, resource: 'user') unless t == teacher
    end

    notification.save!
    notification
  end

end
