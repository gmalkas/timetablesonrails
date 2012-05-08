module Notifications
  class WithdrawActivityTeachingApplication < Notification

    def teacher
      User.find_by_id find_property!('teacher').value
    end

    def activity
      Activity.find_by_id find_property!('activity').value
    end

  end
end

class Notification

  def self.notify_withdraw_activity_teaching_application(school_year, teacher, activity)
    self.notify Notifications::WithdrawActivityTeachingApplication, school_year do |notification|
      notification.properties << NotificationProperty.new(name: 'teacher', value: teacher.id, resource: 'user')
      notification.properties << NotificationProperty.new(name: 'activity', value: activity.id, resource: 'activity')
      
      # Other candidates need to see this notification, therefore we create these properties
      activity.candidates.each do |t|
        notification.properties << NotificationProperty.new(name: "candidate_#{t.id}", value: t.id, resource: 'user') unless t == teacher
      end
    end
  end

end

