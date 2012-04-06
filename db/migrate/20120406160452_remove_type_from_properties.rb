class RemoveTypeFromProperties < ActiveRecord::Migration
  def up
    change_table :notification_properties do |t|
      t.remove :type
    end
  end

  def down
    change_table :notification_properties do |t|
      t.string :type
    end
  end
end
