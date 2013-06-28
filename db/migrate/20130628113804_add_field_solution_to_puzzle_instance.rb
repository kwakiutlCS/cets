class AddFieldSolutionToPuzzleInstance < ActiveRecord::Migration
  def change
    add_column :puzzle_instances, :solution, :string
  end
end
