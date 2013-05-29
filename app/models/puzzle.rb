class Puzzle < ActiveRecord::Base
  attr_accessible :puzzle_type, :subtitle, :title

  has_many :puzzle_instances, dependent: :destroy

  validates :title, presence: true
  validates :puzzle_type, presence: true
end
