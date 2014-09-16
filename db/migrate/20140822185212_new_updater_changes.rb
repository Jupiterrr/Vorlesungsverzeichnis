class NewUpdaterChanges < ActiveRecord::Migration
  def change
    add_column :event_dates, :relation, :string
  end
end
