##
#
# = NotificationPresenter
#
#  Decorates notifications to encapsulate the knowledge of
#  notifications rendering.
#
class NotificationPresenter
  attr_accessor :notification

  def initialize(notification)
    @notification = notification
    
    # Delegate methods specific to the notification (e.g properties)
    # We need this since subclasses of Notification may add their own
    # property accessor (e.g Notifications::NewCourseCandidate#course).
    notification.public_methods(false).each do |meth|
      (class << self; self; end).class_eval do
        define_method meth do |*args|
          notification.send meth, *args
        end
      end
    end
  end

  def type
    @notification.type
  end

  def style
    @notification.style
  end

  def properties
    @notification.properties
  end

  def created_at
    @notification.created_at
  end

  ##
  #
  # Renders the notification-specific view
  #
  def render(context)
    context.render type.underscore, notification: self.notification
  end
end
