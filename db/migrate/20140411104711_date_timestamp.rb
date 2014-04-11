class DateTimestamp < ActiveRecord::Migration
  def change
    add_column(:event_dates, :created_at, :datetime)
    add_column(:event_dates, :updated_at, :datetime)
  end
end
