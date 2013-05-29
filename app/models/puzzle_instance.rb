class PuzzleInstance < ActiveRecord::Base
  attr_accessible :fen, :lines, :rating

  belongs_to :puzzle

  validates :fen, presence: true
  
  serialize :lines
end
