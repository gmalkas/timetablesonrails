class AddResourceToNotificationProperties < ActiveRecord::Migration
  def up
    change_table :notification_properties do |t|
      t.string :resource
    end
  end

  def down
    change_table :notification_properties do |t|
      t.remove :resource
    end
  end
end
