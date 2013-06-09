class PuzzleInstance < ActiveRecord::Base

  before_save :set_defaults

  attr_accessible :fen, :lines, :rating

  belongs_to :puzzle

  

  validates :fen, presence: true
  
  serialize :lines

  private
  def set_defaults
    self.rating ||= 1200
  end

end
