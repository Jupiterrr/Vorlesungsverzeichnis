class AddEventHstore < ActiveRecord::Migration
  def change
    add_column :events, :linker_attributes, :hstore
  end
end
