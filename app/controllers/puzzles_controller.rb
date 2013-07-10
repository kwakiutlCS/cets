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
      stat.recent_attempts += 1

      puzzle = Puzzle.find(params[:puzzle_id])
      if puzzle.subtitle then title = puzzle.subtitle else title = puzzle.title end
          
          
      if params[:result] == "1"
        if stat.streak > 0 then stat.streak += 1 else stat.streak = 1  end
        stat.max_streak = stat.streak if stat.streak > stat.max_streak

        stat.life_solved += 1
        stat.recent_solved += 1
        
        ratio = stat.recent_solved/Float(stat.recent_attempts)
        
        if stat.streak >= puzzle.streak && !stat.solved
          stat.solved = true
          if ratio < puzzle.ratio
            stat.recent_solved = stat.streak
            stat.recent_attempts = stat.streak/puzzle.ratio
          end
          message = current_user.messages.new
          message.sender_id = 17
          message.text = title+": the last attempts were successful."
          message.sender_name = "cets.com"
          message.save
        elsif ratio >= puzzle.ratio && !stat.solved && stat.recent_attempts >= puzzle.streak
               stat.solved = true
               message = current_user.messages.new
               message.sender_id = 17
               message.sender_name = "cets.com"
               message.text = title+": the last attempts were successful."
               message.save
        end
      else
        if stat.streak < 0 then stat.streak -= 1 else stat.streak = -1  end
        if stat.solved && stat.recent_solved/Float(stat.recent_attempts) < puzzle.ratio*0.87
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

    render json: {message:message}
  end

end
