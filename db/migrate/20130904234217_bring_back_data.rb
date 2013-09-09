class BringBackData < ActiveRecord::Migration
  def change
    add_column :events, :data, :hstore
  end
end
