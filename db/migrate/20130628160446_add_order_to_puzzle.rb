class AddOrderToPuzzle < ActiveRecord::Migration
  def change
    add_column :puzzles, :order, :integer
  end
end
