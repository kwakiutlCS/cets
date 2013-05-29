class CreatePuzzleInstances < ActiveRecord::Migration
  def change
    create_table :puzzle_instances do |t|
      t.string :fen
      t.integer :rating
      t.string :lines

      t.timestamps
    end
  end
end
