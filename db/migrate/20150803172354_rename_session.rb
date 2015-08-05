class RenameSession < ActiveRecord::Migration
  def change
    rename_table :sessions, :session_tokens
  end
end
