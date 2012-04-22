class Notification < ActiveRecord::Base
  has_many :properties, class_name: 'NotificationProperty', dependent: :destroy
  belongs_to :school_year

  #
  # Fetches the notifications related to the given user.
  #
  def self.related_to_user(user)
    self.joins(:properties).where('notification_properties.resource = ?', 'user').where('notification_properties.value = ?', user.id).order('notifications.created_at DESC')
  end

  #
  # Fetches the notifications related to the given school year.
  #
  def self.occured_in(school_year)
    self.where('school_year_id = ? ', school_year.id)
  end

  private

  def find_property!(name)
    self.properties.select { |p| p.name == name }.first
  end
end

require_relative './notifications/new_course_candidate'
