class CreatePuzzles < ActiveRecord::Migration
  def change
    create_table :puzzles do |t|
      t.string :title
      t.string :subtitle
      t.string :puzzle_type

      t.timestamps
    end
  end
end
