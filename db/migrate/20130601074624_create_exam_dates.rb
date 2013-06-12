class CreateExamDates < ActiveRecord::Migration
  def change
    create_table :exam_dates do |t|
      t.belongs_to :event
      t.date :date
      t.belongs_to :discipline
      t.hstore :data
      t.string :type
      t.string :name

      t.timestamps
    end
    add_index :exam_dates, :event_id
    add_index :exam_dates, :discipline_id
  end
end
