class RenameStatsModel < ActiveRecord::Migration
  def up
    rename_table :stats, :stat
  end

  def down
    rename_table :stat, :stats
  end
end
