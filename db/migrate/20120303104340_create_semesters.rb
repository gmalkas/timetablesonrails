class CreateSemesters < ActiveRecord::Migration
  def up
    create_table :semesters do |t|
      t.string :name
      t.date :start_date
      t.date :end_date

      t.references :school_year
    end
  end

  def down
    drop_table :semesters
  end
end
