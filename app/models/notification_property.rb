class NotificationProperty < ActiveRecord::Base
  attr_accessible :name, :value, :resource

  belongs_to :notification
end
