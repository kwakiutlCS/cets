class PuzzleInstance < ActiveRecord::Base

  before_save :set_defaults

  attr_accessible :fen, :lines, :rating, :solution

  belongs_to :puzzle

  has_many :comments, dependent: :destroy

  validates :fen, presence: true
  
  serialize :lines
  serialize :solution

  private
  def set_defaults
    self.rating ||= 1200
  end

end
