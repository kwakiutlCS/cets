class AddDefaultsToStats < ActiveRecord::Migration
  def change
    change_column :stats, :streak, :integer, default: 0
    change_column :stats, :life_attempts, :integer, default: 0
    change_column :stats, :life_solved, :integer, default: 0
    
  end
end
