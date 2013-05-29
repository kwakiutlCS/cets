class AddIndexToPuzzleInstances < ActiveRecord::Migration
  def change
    add_index :puzzle_instances, [:puzzle_id]
  end
end
