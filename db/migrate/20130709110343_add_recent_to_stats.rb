class AddRecentToStats < ActiveRecord::Migration
  def change
    add_column :stats, :recent_attempts, :integer
    add_column :stats, :recent_solved, :integer
  end
end
