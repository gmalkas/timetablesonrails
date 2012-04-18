class RemoveClassFromNotificationProperty < ActiveRecord::Migration
  def up
    change_table :notification_properties do |t|
      t.remove :class
    end
  end

  def down
    change_table :notification_properties do |t|
      t.string :class
    end
  end
end
