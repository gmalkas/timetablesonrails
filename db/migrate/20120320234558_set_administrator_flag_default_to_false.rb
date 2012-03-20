class SetAdministratorFlagDefaultToFalse < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.remove :administrator
      t.boolean :administrator, default: false
    end
  end

  def down
    change_table :users do |t|
      t.remove :administrator
      t.boolean :administrator
    end
  end
end
