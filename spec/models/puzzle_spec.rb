require 'spec_helper'

describe Puzzle do
  before { @puzzle = Puzzle.new(title: "Example User", puzzle_type: "puzzle") }

  subject { @puzzle }

  describe "correct puzzle" do
    
    it { should respond_to(:title) }
    it { should respond_to(:puzzle_type)}
    it { should respond_to(:subtitle) }
    it { should be_valid }
  end

  describe "incorrect puzzle" do
    before { @puzzle.title = "" }
    it { should_not be_valid }
  end

end
