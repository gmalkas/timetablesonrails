class NotificationPresenter
  attr_accessor :notification

  def initialize(notification)
    @notification = notification
    
    # Delegate methods specific to the notification (e.g properties)
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

  def render(context)
    context.render type.underscore, notification: self.notification
  end
end
