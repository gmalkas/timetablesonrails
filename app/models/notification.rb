##
#
# = Notification
#
# Defines a basic notification. A notification is composed of properties,
# which associate resources (e.g users, courses) with an event.
#
# Notifications should not be created by directly initializing instances of this
# class. Subclasses of Notification must add factory methods that encapsulate the
# structure of each type of notification.
#
# == See also
#
# NotificationProperty
#
class Notification < ActiveRecord::Base
  has_many :properties, class_name: 'NotificationProperty', dependent: :destroy
  belongs_to :school_year

  scope :last_week, lambda { where(created_at: (1.week.ago)..(Time.zone.now) ) }
  scope :last_two_weeks, lambda { where(created_at: (2.week.ago)..(Time.zone.now)) }
  scope :last_month, lambda { where(created_at: (1.month.ago)..(Time.zone.now) ) }
  scope :last_three_months, lambda { where(created_at: (3.month.ago)..(Time.zone.now) ) }
  scope :last_six_months, lambda { where(created_at: (6.month.ago)..(Time.zone.now) ) }

  ##
  #
  # Fetches the notifications related to the given resource (e.g user, course, activity).
  #
  def self.related_to(resource)
    self.joins(:properties).where('notification_properties.resource = ?', resource.class.name.downcase)
                           .where('notification_properties.value = ?', resource.id)
                           .order('notifications.created_at DESC')
  end

  ##
  #
  # Fetches the notifications related to the given school year.
  #
  def self.occured_in(school_year)
    self.where('school_year_id = ? ', school_year.id)
  end

  private

  ##
  #
  #
  #
  def find_property!(name)
    self.properties.select { |p| p.name == name }.first
  end

  ##
  #
  # This helper method is used by Notification's subclasses to create new
  # notifications.
  # 
  # == Example
  #
  # Given a subclass NewUserNotification, we could declare a new factory method:
  #
  #   def Notification.notify_new_user(school_year, new_user)
  #     Notification.notify(NewUser, school_year) do
  #       # Add properties here
  #     end
  #   end
  #
  def self.notify(notification_type, school_year)
    notification = notification_type.new
    notification.school_year = school_year

    yield notification

    notification.save!
    notification
  end
end

# Rails autoloads a class the first time it sees a unknown constante
# But that would not work with Notification since specific factory methods are declared
# in subclasses which redefine the Notification class to add methods.
# Hence, a call to Notification.notify_new_user would raise an error, since Rails
# would only load the Notification class, and not the Notifications::NewUser class
# that actually declares the Notification.notify_new_user method.
#
# Therefore, we need to force the loading of these subclasses in order
# to have access to specific factory methods.
require_relative './notifications/new_course_candidate'
require_relative './notifications/withdraw_course_management_application'
require_relative './notifications/choose_course_manager'
require_relative './notifications/course_manager_resigned'
require_relative './notifications/new_activity_candidate'
require_relative './notifications/choose_activity_teacher'
require_relative './notifications/activity_teacher_resigned'
require_relative './notifications/withdraw_activity_teaching_application'
