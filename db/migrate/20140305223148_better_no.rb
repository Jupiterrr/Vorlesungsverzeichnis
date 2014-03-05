class BetterNo < ActiveRecord::Migration
  def change
    rename_column :events, :nr, :orginal_no
    add_column :events, :no, :string
  end
end
