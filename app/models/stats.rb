class Stats < ActiveRecord::Base
  attr_accessible :life_attempts, :life_solved, :recent_attempts, :recent_solved
end
