class PuzzlesController < ApplicationController
  def index
    @puzzles = Puzzle.order("difficulty").group("title")
  end

  def show
    @puzzle = Puzzle.find(params[:id])
    puzzles = Puzzle.find(:all, conditions: ["title = ?", @puzzle.title])
    
    instances = []
    puzzles.each do |p|
      p.puzzle_instances.each { |i| instances << i }
    end
    
    offset = rand(instances.count)

    @instance = instances[offset]
    @puzzle = Puzzle.find(:all, conditions: ["id = ?", @instance.puzzle_id])[0]

    @side = "black"
    @side = "white" if @instance.fen.split()[1] == "w"

  end


  def markSolved
    if current_user
      stat = current_user.stats.find(:all, conditions: ["puzzle_id = ?", params[:puzzle_id]])[0]
      stat.life_attempts += 1

      if params[:result] == "1"
        stat.streak += 1
        stat.life_solved += 1
        if stat.streak == 7 || stat.life_solved/stat.life_attempts > 0.85
          stat.solved = true
        end
      else
        stat.streak = 0
        if stat.solved && stat.life_solved/stat.life_attempts < 0.7
          stat.solved = false
        end
      end

      stat.save
    end

    render json: {}
  end

end
