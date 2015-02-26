require_relative 'pieces'
require_relative 'board'
require_relative 'players'
require 'colorize'

class Game
  def initialize(player1, player2)
    @board = Board.new
    @player1 = player1
    @player1.color = :white
    @player2 = player2
    @player2.color = :black
  end

  def play_game
    @board.display
    current_player = @player1

    until @board.check_mate?(current_player.color)
      puts "#{current_player.color.to_s.capitalize}\'s turn to move:"

      begin
        from, to = current_player.input(@board.dup)
        if !@board.check_turn(from, current_player.color)
          puts "Wrong color! Try again!"
          next
        end
          @board.move(from, to)

        rescue ArgumentError => e
          puts e
          retry
        rescue NotImplemented => e
          puts e
          return nil
      end

      @board.display
      current_player = switch_player(current_player)
    end

    puts "Check mate! #{switch_player(current_player).color.to_s.upcase} WINS!"
  end

  private

  def switch_player(player)
    player == @player1 ? @player2 : @player1
  end
end


if __FILE__ == $PROGRAM_NAME
  # hum1 = HumanPlayer.new
  # hum2 = ComputerPlayer.new
  #
  # g = Game.new(hum1, hum2)
  # g.play_game

  b = Board.new
  b.move([6,5],[5,5])
  b.move([1,4],[3,4])
  b.move([6,6],[4,6])

  n = BoardNode.new(b, :white, 0, 0)
  p n.dfs

end
