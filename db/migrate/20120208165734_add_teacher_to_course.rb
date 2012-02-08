class AddTeacherToCourse < ActiveRecord::Migration
  def change
    change_table :courses do |t|
      t.string :teacher
    end
  end
end
