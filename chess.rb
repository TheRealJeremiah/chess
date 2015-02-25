class Piece
  attr_reader :color, :icon

  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board
  end

  def possible_moves
    raise "Moves not implemented"
  end

  def add(pos, dir)
    [(pos[0] + dir[0]), (pos[1] + dir[1])]
  end

  def move_to(pos)
    @pos = pos
  end

end

class SlidingPiece < Piece
  def possible_moves
    moves = []
    move_dirs.each do |direction|
      current_pos = add(@pos, direction)

      while @board.empty?(current_pos)
        moves << current_pos

        current_pos = add(current_pos, direction)
      end

      target_color = @board.color_at(current_pos)

      unless target_color.nil? || target_color == @color
        moves << current_pos
      end
    end

    moves
  end

  def move_dirs
    raise "Move_dirs not implemented"
  end
end

class Rook < SlidingPiece
  def initialize(pos, color, board)
    super
    @icon = '♖' if color == :white
    @icon = '♜' if color == :black
  end
  def move_dirs
    [[1, 0], [0, 1], [-1, 0], [0, -1]]
  end
end

class Bishop <SlidingPiece
  def initialize(pos, color, board)
    super
    @icon = '♗' if color == :white
    @icon = '♝' if color == :black
  end
  def move_dirs
    [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end

class Queen <SlidingPiece
  def initialize(pos, color, board)
    super
    @icon = '♕' if color == :white
    @icon = '♛' if color == :black
  end
  def move_dirs
    [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end

class SteppingPiece < Piece
  def possible_moves
    possible = []
    moves.each do |move|
      new_pos = add(@pos, move)
      if @board.empty?(new_pos)
        possible << new_pos
      else
        color_at_pos = @board.color_at(new_pos)
        possible << new_pos unless color_at_pos == @color || color_at_pos.nil?
      end
    end
    possible
  end

  def moves
    raise "Moves not implemented!"
  end
end

class Knight < SteppingPiece
  def initialize(pos, color, board)
    super
    @icon = '♘' if color == :white
    @icon = '♞' if color == :black
  end
  def moves
    [[-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1]]
  end
end

class King < SteppingPiece
  def initialize(pos, color, board)
    super
    @icon = '♔' if color == :white
    @icon = '♚' if color == :black
  end
  def moves
    [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end

class Pawn < Piece
  def initialize(pos, color, board)
    super
    @moved = false
    @icon = '♙' if color == :white
    @icon = '♟' if color == :black
  end

  def possible_moves
    moves = []
    if @color == :black
      new_pos = add(@pos, [1,0])
      moves << new_pos if @board.empty?(new_pos)
      new_pos = add(@pos, [2,0])
      moves << new_pos if @board.empty?(new_pos) && !@moved
      new_pos = add(@pos, [1,1])
      moves << new_pos if @board.color_at(new_pos) == :white
      new_pos = add(@pos, [1,-1])
      moves << new_pos if @board.color_at(new_pos) == :white
    else
      new_pos = add(@pos, [-1,0])
      moves << new_pos if @board.empty?(new_pos)
      new_pos = add(@pos, [-2,0])
      moves << new_pos if @board.empty?(new_pos) && !@moved
      new_pos = add(@pos, [-1,1])
      moves << new_pos if @board.color_at(new_pos) == :black
      new_pos = add(@pos, [-1,-1])
      moves << new_pos if @board.color_at(new_pos) == :black
    end

    moves
  end

  def move_to(pos)
    super
    @moved = true
  end
end

class Board

  def initialize
    @squares = Array.new(8) { Array.new(8) }
    set_pieces
  end

  def set_pieces

    @squares[7][0] = Rook.new([7,0], :white, self)
    @squares[7][1] = Knight.new([7,1], :white, self)
    @squares[7][2] = Bishop.new([7,2], :white, self)
    @squares[7][3] = Queen.new([7,3], :white, self)
    @squares[7][4] = King.new([7,4], :white, self)
    @squares[7][5] = Bishop.new([7,5], :white, self)
    @squares[7][6] = Knight.new([7,6], :white, self)
    @squares[7][7] = Rook.new([7,7], :white, self)

    8.times do |col|
      @squares[6][col] = Pawn.new([6,col], :white, self)
    end

    @squares[0][0] = Rook.new([0,0], :black, self)
    @squares[0][1] = Knight.new([0,1], :black, self)
    @squares[0][2] = Bishop.new([0,2], :black, self)
    @squares[0][3] = Queen.new([0,3], :black, self)
    @squares[0][4] = King.new([0,4], :black, self)
    @squares[0][5] = Bishop.new([0,5], :black, self)
    @squares[0][6] = Knight.new([0,6], :black, self)
    @squares[0][7] = Rook.new([0,7], :black, self)

    8.times do |col|
      @squares[1][col] = Pawn.new([1,col], :black, self)
    end

  end

  def display
    puts "  a b c d e f g h"
    @squares.each_with_index do |row, idx|
      string = (8-idx).to_s + " "
      row.each do |col|
        if col.nil?
          string += "_"
        else
          string += col.icon
        end
        string += " "
      end
      puts string
    end
  end

  def move(from, to)
    row1, col1 = from
    row2, col2 = to

    piece = @squares[row1][col1]
    moves = piece.possible_moves

    if moves.include?(to)
      @squares[row2][col2] = @squares[row1][col1]
      @squares[row1][col1] = nil
      @squares[row2][col2].move_to(to)
    else
      raise ArgumentError.new("That piece cannot make that move!")
    end
  end


  def check(color)
  end

  def dup
  end

  def off_board?(pos)
    row, col = pos
    if row < 0 || row > 7 || col < 0 || col > 7
      return true
    end

    false
  end

  def empty?(space)
    row, col = space
    if off_board?(space)
      return false
    end

    @squares[row][col].nil?
  end

  def color_at(pos)
    row, col = pos
    return nil if off_board?(pos) || @squares[row][col].nil?
    @squares[pos[0]][pos[1]].color
  end
end

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
end
