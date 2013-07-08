class AddDescriptionToPuzzleInstances < ActiveRecord::Migration
  def change
    add_column :puzzle_instances, :description, :string
  end
end
