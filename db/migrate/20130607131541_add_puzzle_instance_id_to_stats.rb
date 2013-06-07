class AddPuzzleInstanceIdToStats < ActiveRecord::Migration
  def change
    add_column :stats, :puzzle_instance_id, :integer
  end
end
