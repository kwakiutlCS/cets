class Stat < ActiveRecord::Base
  

  attr_accessible :life_attempts, :life_solved, :streak
  
  belongs_to :user
  belongs_to :puzzle

  

end
