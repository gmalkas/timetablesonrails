class RemoveSchoolYearReferenceFromNotifications < ActiveRecord::Migration
  def up
    change_table :notifications do |t|
      t.remove :school_year_id
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
