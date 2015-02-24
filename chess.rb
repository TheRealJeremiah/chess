class Piece
  attr_reader :color

  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board
  end

  def move(pos)
  end

  def possible_moves
    raise "Moves not implemented"
  end

  def add(pos, dir)
    [(pos[0] + dir[0]), (pos[1] + dir[1])]
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
  def move_dirs
    [[1, 0], [0, 1], [-1, 0], [0, -1]]
  end
end

class Bishop <SlidingPiece
  def move_dirs
    [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end

class Queen <SlidingPiece
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
  def moves
    [[-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1]]
  end
end

class King < SteppingPiece
  def moves
    [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end

class Pawn < Piece

end

class Board

  def initialize
    @squares = Array.new(8) { Array.new(8) }
    @squares[5][5] = Queen.new([5,5], :white, self)
  end

  def check(color)
  end

  def dup
  end

  def empty?(space)
    row, col = space
    if row < 0 || row > 7 || col < 0 || col > 7
      return false
    end

    @squares[row][col].nil?
  end

  def color_at(pos)
    row, col = pos
    return nil if row < 0 || row > 7 || col < 0 || col > 7
    @squares[pos[0]][pos[1]].color
  end
end
