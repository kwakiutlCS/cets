class AddPuzzleidToPuzzleInstance < ActiveRecord::Migration
  def change
    add_column :puzzle_instances, :puzzle_id, :integer
  end
end
