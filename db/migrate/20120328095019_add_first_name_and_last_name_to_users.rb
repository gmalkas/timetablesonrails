class AddFirstNameAndLastNameToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.remove :name
      t.string :firstname
      t.string :lastname
    end
  end

  def down
    t.remove :lastname
    t.remove :firstname
    t.string :name
  end
end
