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

  def dup(board)
    self.class.new(@pos.dup, @color, board)
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
