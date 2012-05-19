##
#
# = NotificationProperty
#
# Models a relationship between a notification and a resource (e.g course).
# 
# == See also
# 
# Notification
#
class NotificationProperty < ActiveRecord::Base
  attr_accessible :name, :value, :resource

  belongs_to :notification
end
