class UserHstor < ActiveRecord::Migration
  def change
    add_column :users, :data, :hstore
  end
end
