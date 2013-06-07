class Stat < ActiveRecord::Base
  

  attr_accessible :life_attempts, :life_solved, :recent_attempts, :recent_solved
  
  belongs_to :user
  belongs_to :puzzle

  

end
