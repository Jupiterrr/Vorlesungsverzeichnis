class DepthCache < ActiveRecord::Migration
  def change
    add_column :vvzs, :ancestry_depth, :integer, :default => 0
  end
end
