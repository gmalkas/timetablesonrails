class NotificationProperty < ActiveRecord::Base
  attr_accessible :name, :value

  belongs_to :notification
end
