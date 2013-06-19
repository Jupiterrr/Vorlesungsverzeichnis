class HiddenExamDates < ActiveRecord::Migration
  def change
    add_column :exam_dates, :deleted_at, :time
  end
end
