class Notification < ActiveRecord::Base
  has_many :properties, class_name: 'NotificationProperty', dependent: :destroy
  belongs_to :school_year

  scope :last_week, lambda { where(created_at: (1.week.ago)..(Time.zone.now) ) }
  scope :last_two_weeks, lambda { where(created_at: (2.week.ago)..(Time.zone.now)) }
  scope :last_month, lambda { where(created_at: (1.month.ago)..(Time.zone.now) ) }
  scope :last_three_months, lambda { where(created_at: (3.month.ago)..(Time.zone.now) ) }

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

# Necessary because of Rails autoloading
require_relative './notifications/new_course_candidate'
require_relative './notifications/withdraw_course_management_application'
