##
#
# = Notifications::ChooseActivityTeacher
#
# This notification is created when a teacher has been chosen to
# teach an activity.
#
module Notifications
  class ChooseActivityTeacher < Notification

    ##
    # 
    # The 'picker' is either an administrator or the course's manager.
    #
    def picker
      User.find_by_id find_property!('picker').value
    end

    def teacher
      User.find_by_id find_property!('teacher').value
    end

    def activity
      Activity.find_by_id find_property!('activity').value
    end

  end
end

class Notification

  def self.notify_activity_teacher_chosen(school_year, picker, teacher, activity)
    self.notify Notifications::ChooseActivityTeacher, school_year do |notification|
      notification.style = 'success'
      
      # The 'picker' is the user that chose the teacher, e.g the course's manager or an administrator
      notification.properties << NotificationProperty.new(name: 'picker', value: picker.id, resource: 'user')
      
      # The course's manager needs to be notified, even when he's not the one who chose the teacher
      notification.properties << NotificationProperty.new(name: 'manager', value: activity.course.manager.id, resource: 'user') if activity.course.manager

      notification.properties << NotificationProperty.new(name: 'teacher', value: teacher.id, resource: 'user')
      notification.properties << NotificationProperty.new(name: 'activity', value: activity.id, resource: 'activity')
      
      # Other candidates need to see this notification, therefore we create these properties
      activity.candidates.each do |t|
        notification.properties << NotificationProperty.new(name: "candidate_#{t.id}", value: t.id, resource: 'user') unless t == teacher
      end
    end
  end

end

