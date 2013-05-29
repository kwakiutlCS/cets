class PuzzlesController < ApplicationController
  def index
    @puzzles = Puzzle.all
  end

  def show
    @puzzle = Puzzle.find(params[:id])
    offset = rand(@puzzle.puzzle_instances.count)

    @instance = @puzzle.puzzle_instances.first(offset: offset)
  end

end
