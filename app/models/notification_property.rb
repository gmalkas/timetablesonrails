class NotificationProperty < ActiveRecord::Base
  attr_accessible :type, :name, :value

  belongs_to :notification
end
