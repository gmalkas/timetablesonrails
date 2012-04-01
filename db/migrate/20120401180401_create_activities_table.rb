class CreateActivitiesTable < ActiveRecord::Migration
  def up
    create_table :activities do |t|
      t.string :type
      t.integer :duration
      t.integer :groups
      t.references :course

      t.timestamps
    end
  end

  def down
    drop_table :activities
  end
end
