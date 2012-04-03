class CreateNotificationsTable < ActiveRecord::Migration
  def up
    create_table :notifications do |t|
      t.string :type
      t.string :style

      t.timestamps
    end
  end

  def down
    drop_table :notifications
  end
end
