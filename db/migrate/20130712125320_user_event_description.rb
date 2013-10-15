class UserEventDescription < ActiveRecord::Migration
  def change
    add_column :events, :user_text_md, :text
  end
end
