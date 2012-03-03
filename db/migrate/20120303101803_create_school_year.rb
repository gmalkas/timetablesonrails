class CreateSchoolYear < ActiveRecord::Migration
  def up
    create_table :school_years do |t|
      t.date :start_year
      t.date :end_year
      t.boolean :archived, default: false
      t.boolean :activated, default: false

      t.timestamps
    end
  end

  def down
    drop_table :school_years
  end
end
