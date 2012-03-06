class AddSemesterReferencesAndManagerReferencesToCourses < ActiveRecord::Migration
  def change
    change_table :courses do |t|
      t.references :semester
      t.references :manager
    end
  end
end
