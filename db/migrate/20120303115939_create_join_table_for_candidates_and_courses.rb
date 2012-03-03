class CreateJoinTableForCandidatesAndCourses < ActiveRecord::Migration
  def up
    create_table :candidates_courses, id: false do |t|
      t.references :candidate
      t.references :course
    end
  end

  def down
    drop_table :candidates_courses
  end
end
