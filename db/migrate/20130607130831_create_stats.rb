class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.integer :recent_attempts
      t.integer :recent_solved
      t.integer :life_attempts
      t.integer :life_solved

      t.timestamps
    end
  end
end
