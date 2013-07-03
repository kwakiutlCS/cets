class Comment < ActiveRecord::Base
  attr_accessible :instance_id, :text, :user_id

  belongs_to :user
  belongs_to :puzzle_instance


  validates :text, presence: true
  validates :instance_id, presence: true
  validates :user_id, presence: true

end
