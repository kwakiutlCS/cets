class PuzzlesController < ApplicationController
  def index
    @user = current_user
    @puzzles = Puzzle.order("difficulty").group("title").paginate(page:params[:page], per_page:15)
    
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

    @comments = Comment.where(instance_id: @instance.id)
    if user_signed_in?
      @comment = current_user.comments.build(instance_id:@instance.id)
    end

  end


  def markSolved
    if current_user
      stat = current_user.stats.find(:all, conditions: ["puzzle_id = ?", params[:puzzle_id]])[0]
      stat.life_attempts += 1

      puzzle = Puzzle.find(params[:puzzle_id])
      if puzzle.subtitle then title = puzzle.subtitle else title = puzzle.title end
          
          
      if params[:result] == "1"
        stat.streak += 1
        stat.life_solved += 1
        
        ratio = stat.life_solved/Float(stat.life_attempts)

        if stat.streak == 10 && !stat.solved
          stat.solved = true
          if ratio < 0.85
            stat.life_solved = stat.streak
            stat.life_attempts = stat.streak/0.85
          end
          message = current_user.messages.new
          message.sender_id = 17
          message.text = title+": the last attempts were successful."
          message.sender_name = "cets.com"
          message.save
        elsif ratio > 0.85 && !stat.solved && stat.life_attemps > 10
               stat.solved = true
               message = current_user.messages.new
               message.sender_id = 17
               message.sender_name = "cets.com"
               message.text = title+": the last attempts were successful."
               message.save
        end
      else
        stat.streak = 0
        if stat.solved && stat.life_solved/Float(stat.life_attempts) < 0.75
          stat.solved = false
          message = current_user.messages.new
          message.sender_id = 17
          message.sender_name = "cets.com"
          message.text = title+": the last attempts were unsuccessful."
          message.save
         
        end
      end

      stat.save
    end

    render json: {}
  end

end
