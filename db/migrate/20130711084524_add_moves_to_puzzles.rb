class AddMovesToPuzzles < ActiveRecord::Migration
  def change
    add_column :puzzles, :moves, :integer, default: 0
    add_column :puzzles, :label, :boolean, default: false
  end
end
