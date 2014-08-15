class AddRememberMe < ActiveRecord::Migration
  create_table :sessions do |t|
    t.references :user
    t.string :token
    t.hstore :data
    t.timestamps
  end
  add_index :sessions, :token
end
