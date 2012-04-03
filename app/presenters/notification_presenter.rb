class NotificationPresenter
  attr_accessor :notification

  def initialize(notification)
    @notification = notification
  end

  def type
    @notification.type
  end

  def properties
    @notification.properties
  end

  def created_at
    @notification.created_at
  end

  def render(context)
    context.render File.join('notifications', type)
  end
end
