class Notification < ActiveRecord::Base
  has_many :properties, class_name: 'NotificationProperty', dependent: :destroy

  private

  def find_property!(name)
    self.properties.select { |p| p.name == name }.first.value
  end
end
