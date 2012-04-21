class ReallyAddSchoolYearReferenceToNotifications < ActiveRecord::Migration
  def up
    change_table :notifications do |t|
      t.references :school_year
    end
  end

  def down
    change_table :notifications do |t|
      t.remove :school_year_id
    end
  end
end
