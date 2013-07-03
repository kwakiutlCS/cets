class AddIndexs < ActiveRecord::Migration
  def up
    add_index :stats, :puzzle_id
    add_index :stats, :user_id
    add_index :comments, :instance_id
  end

  def down
  end
end
