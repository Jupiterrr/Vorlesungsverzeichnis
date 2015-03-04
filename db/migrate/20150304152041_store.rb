class Store < ActiveRecord::Migration
  def change
    create_table :store, id: false do |t|
      t.string :key, null: false
      t.string :value
    end
    add_index :store, :key, unique: true
  end
end
