class RenameDescriptionColumn < ActiveRecord::Migration
  def up
    rename_column :puzzles, :descrition, :description
  end

  def down
  end
end
