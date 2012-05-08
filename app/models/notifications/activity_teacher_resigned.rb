module Notifications
  class ActivityTeacherResigned < Notification

    def teacher
      User.find_by_id find_property!('teacher').value
    end

    def activity
      Activity.find_by_id find_property!('activity').value
    end

  end
end

class Notification

  def self.notify_activity_teacher_resigned(school_year, teacher, activity)
    self.notify Notifications::ActivityTeacherResigned, school_year do |notification|
      notification.properties << NotificationProperty.new(name: 'teacher', value: teacher.id, resource: 'user')
      notification.properties << NotificationProperty.new(name: 'activity', value: activity.id, resource: 'activity')
    end
  end

end

