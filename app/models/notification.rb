class Notification < ActiveRecord::Base
  has_many :properties, class_name: 'NotificationProperty', dependent: :destroy
  belongs_to :school_year

  def self.for_user(user, school_year)
    self.joins(:properties).where('notifications.school_year_id = ?', school_year.id).where('notification_properties.resource = ?', 'user').where('notification_properties.value = ?', user.id).order('notifications.created_at DESC')
  end

  private

  def find_property!(name)
    self.properties.select { |p| p.name == name }.first
  end
end
