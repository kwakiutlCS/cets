class RenameRecentColumnStats < ActiveRecord::Migration
  def up
    remove_column :stat, :recent_attempts
    rename_column :stat, :recent_solved, :streak
  end

  
end
