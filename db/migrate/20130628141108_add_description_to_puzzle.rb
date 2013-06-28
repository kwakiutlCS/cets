class AddDescriptionToPuzzle < ActiveRecord::Migration
  def change
    add_column :puzzles, :descrition, :string
  end
end
