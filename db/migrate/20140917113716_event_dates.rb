class EventDates < ActiveRecord::Migration
  def change
    add_column :event_dates, :term, :string
  end
end
