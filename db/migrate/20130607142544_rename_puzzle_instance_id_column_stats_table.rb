class RenamePuzzleInstanceIdColumnStatsTable < ActiveRecord::Migration
  def up
    rename_column :stats, :puzzle_instance_id, :puzzle_id
  end

  def down
  end
end
