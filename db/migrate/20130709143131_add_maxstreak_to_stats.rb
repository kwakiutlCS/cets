class AddMaxstreakToStats < ActiveRecord::Migration
  def change
    add_column :stats, :max_streak, :integer, default:0
  end
end
