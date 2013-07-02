# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    # add custom create logic here
    super
    puzzles = Puzzle.all
    puzzles.each do |p|
      stat = @user.stats.build
      stat.puzzle_id = p.id
      stat.life_attempts = 0
      stat.life_solved = 0
      stat.streak = 0
      stat.save
    end
  end

  def update
    super
  end
end 
