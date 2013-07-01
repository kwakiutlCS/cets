class PuzzlesController < ApplicationController
  def index
    @user = current_user
    @puzzles = Puzzle.order("difficulty").group("title")
    
    @solved = {}
    @puzzles.each do |p|
      if @user
        @solved[p.title] = true
        i_array = Puzzle.where(title: p.title)
        i_array.each do |i| 
          stat = @user.stats.where(puzzle_id: i.id)
          @solved[p.title] = false unless stat[0].solved
        end
      else
        @solved[p.title] = false
      end  
    end
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
        
        ratio = stat.life_solved/Float(stat.life_attempts)

        if stat.streak == 8
          stat.solved = true
          if ratio < 0.85
            stat.life_solved = stat.streak
            stat.life_attempts = stat.streak/0.85
          end
        elsif ratio > 0.85
               stat.solved = true
        end
      else
        stat.streak = 0
        if stat.solved && stat.life_solved/Float(stat.life_attempts) < 0.75
          stat.solved = false
        end
      end

      stat.save
    end

    render json: {}
  end

end
