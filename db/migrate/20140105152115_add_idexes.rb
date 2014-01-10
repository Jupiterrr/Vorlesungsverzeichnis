class AddIdexes < ActiveRecord::Migration

  def change
    add_index :poi_groups_pois, [:poi_group_id, :poi_id]
    add_index :events_users, [:user_id, :event_id]
  end

end
