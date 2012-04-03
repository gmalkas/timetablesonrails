class CreateNotificationPropertiesTable < ActiveRecord::Migration
  def up
    create_table :notification_properties do |t|
      t.string :name
      t.string :type
      t.string :value
      t.references :notification
    end
  end

  def down
    drop_table :notification_properties
  end
end
