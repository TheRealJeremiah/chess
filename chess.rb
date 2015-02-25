require_relative 'pieces'
require_relative 'board'

class Game
  def initialize
    @board = Board.new
  end

  def play_game
    @board.display

    while true
      input = gets.chomp
      from, to = parse(input)
      @board.move(from, to)
      @board.display
      #puts @board.check(:white)
    end
  end

  def parse(input)
    letters = ('a'..'h').to_a
    col1 = letters.index(input[0])
    row1 = 8 - input[1].to_i
    col2 = letters.index(input[3])
    row2 = 8 - input[4].to_i

    [[row1,col1],[row2,col2]]
  end
end


if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.play_game
  # b = Board.new
  # b.display
  # b.move([6,4],[4,4])
  # b.display
  #
  # b2 = b.dup
  # b2.display
  #
  # b2.move([6,3],[5,3])
  # b2.display
  # b.display

end
