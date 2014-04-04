class IndexTimetableId < ActiveRecord::Migration
  def change
    add_index :users, [:timetable_id]
  end
end
