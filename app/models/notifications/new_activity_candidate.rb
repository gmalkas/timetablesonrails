##
#
# = Notifications::NewActivityCandidate
#
# This notification is created when there is a new candidate for
# an activity's teaching position.
#
module Notifications
  class NewActivityCandidate < Notification

    def candidates
      find_property!('candidates').value
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

  def self.notify_new_activity_candidate(school_year, teacher, activity)
    self.notify Notifications::NewActivityCandidate, school_year do |notification|
      notification.properties << NotificationProperty.new(name: 'teacher', value: teacher.id, resource: 'user')
      notification.properties << NotificationProperty.new(name: 'activity', value: activity.id, resource: 'activity')
      notification.properties << NotificationProperty.new(name: 'candidates', value: activity.candidates.size)
      
      # Other candidates need to see this notification, therefore we create these properties
      activity.candidates.each do |t|
        notification.properties << NotificationProperty.new(name: "candidate_#{t.id}", value: t.id, resource: 'user') unless t == teacher
      end

      notification.style = (activity.conflict?) ? 'error' : ''
    end
  end

end
