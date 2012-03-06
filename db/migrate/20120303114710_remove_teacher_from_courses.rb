class RemoveTeacherFromCourses < ActiveRecord::Migration
  def up
    change_table :courses do |t|
      t.remove :teacher
    end
  end

  def down
    change_table :courses do |t|
      t.string :teacher
    end
  end
end
