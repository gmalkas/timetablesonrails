class Notification < ActiveRecord::Base
  has_many :properties, class_name: 'NotificationProperty', dependent: :destroy
end
