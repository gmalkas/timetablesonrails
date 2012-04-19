class AddSchoolYearReferenceToNotifications < ActiveRecord::Migration
  def change
    change_table :notifications do |t|
      t.references :school_year
    end
  end
end
