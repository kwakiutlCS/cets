class AddRatioToPuzzles < ActiveRecord::Migration
  def change
    add_column :puzzles, :streak, :integer
    add_column :puzzles, :ratio, :float
  end
end
