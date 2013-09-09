class BetterDates < ActiveRecord::Migration

  def change
    add_column :event_dates, :uuid, :string
    add_column :event_dates, :api_last_modified, :datetime
    add_column :event_dates, :data, :hstore
  end

end
