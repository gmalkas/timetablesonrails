##
# = ActivityObserver
#
# Destroys notifications related to a destroyed activity.
#
class ActivityObserver < ActiveRecord::Observer

  def after_destroy(activity)
    Notification.related_to(activity).destroy_all  
  end
end
