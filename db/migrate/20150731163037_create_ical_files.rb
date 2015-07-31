require_dependency "ical_service"
class CreateIcalFiles < ActiveRecord::Migration

  def up
    make_changes
    User.all.each do |user|
      events = user.events.includes(:event_dates => :room)
      user.create_ical_file!(
        reference_key: user.timetable_id,
        content: IcalService.ical(events)
      )
    end
  end

  def down
    revert { make_changes }
  end

  def make_changes
    create_table :ical_files do |t|
      t.references :user
      t.text :content
      t.string :reference_key
      t.timestamps
    end
    add_index :ical_files, :user_id
    add_index :ical_files, :reference_key
  end

end
