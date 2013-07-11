class DefaultValuesForStats < ActiveRecord::Migration
  def up
    change_column :stats, :recent_solved, :integer, default: 0
    change_column :stats, :recent_attempts, :integer, default: 0
    
  end

  def down
  end
end
