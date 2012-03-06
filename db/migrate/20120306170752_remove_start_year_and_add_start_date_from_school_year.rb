class RemoveStartYearAndAddStartDateFromSchoolYear < ActiveRecord::Migration
  def up
    change_table :school_years do |t|
      t.remove :start_year
      t.remove :end_year
      t.date :start_date
      t.date :end_date
    end
  end

  def down
    change_table :school_years do |t|
      t.remove :end_date
      t.remove :start_date
      t.date :end_year
      t.date :start_year
    end
  end
end
