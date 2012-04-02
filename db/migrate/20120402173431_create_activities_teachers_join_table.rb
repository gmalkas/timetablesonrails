class CreateActivitiesTeachersJoinTable < ActiveRecord::Migration
  def up
    create_table :activities_teachers, id: false do |t|
      t.references :activity
      t.references :teacher
    end
  end

  def down
    drop_table :activities_teachers
  end
end
