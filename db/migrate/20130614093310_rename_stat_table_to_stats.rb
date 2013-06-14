class RenameStatTableToStats < ActiveRecord::Migration
  def up
    rename_table :stat, :stats
  end

  def down
  end
end
