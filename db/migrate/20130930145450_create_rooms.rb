class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.references :poi
      t.string :uuid
      t.string :name
      t.hstore :data

      t.timestamps
    end
    rename_column :event_dates, :room, :room_name
    add_column :event_dates, :room_id, :integer
    add_index :event_dates, :room_id
    add_index :rooms, :poi_id
  end
end
