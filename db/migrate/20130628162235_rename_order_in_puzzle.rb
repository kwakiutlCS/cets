class RenameOrderInPuzzle < ActiveRecord::Migration
  def up
    rename_column :puzzles, :order, :difficulty
  end

  def down
  end
end
