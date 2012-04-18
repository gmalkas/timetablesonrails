class Notification < ActiveRecord::Base
  has_many :properties, class_name: 'NotificationProperty', dependent: :destroy

  def self.for_user(user)
    self.joins(:properties).where('notification_properties.resource = ?', 'user').where('notification_properties.value = ?', user.id).order('notifications.created_at DESC')
  end

  private

  def find_property!(name)
    self.properties.select { |p| p.name == name }.first
  end
end
