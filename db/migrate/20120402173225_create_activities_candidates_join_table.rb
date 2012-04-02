class CreateActivitiesCandidatesJoinTable < ActiveRecord::Migration
  def up
    create_table :activities_candidates, id: false do |t|
      t.references :activity
      t.references :candidate
    end
  end

  def down
    drop_table :activities_candidates
  end
end
