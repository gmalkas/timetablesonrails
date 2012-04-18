class AddClassToNotificationProperties < ActiveRecord::Migration
  def change
    change_table :notification_properties do |t|
      t.string :class
    end
  end
end
