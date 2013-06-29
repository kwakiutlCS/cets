class AddSolvedToStats < ActiveRecord::Migration
  def change
    add_column :stats, :solved, :boolean, default: false
  end
end
