class AddSessionTokenToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :session_token
    end
  end
end
