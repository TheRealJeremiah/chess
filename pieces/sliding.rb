class SlidingPiece < Piece
  def possible_moves
    moves = []
    move_dirs.each do |direction|
      moves += moves_in_direction(direction)
    end
    moves
  end

  private

  def moves_in_direction(direction)
    moves = []
    current_pos = add(@pos, direction)
    while @board.empty?(current_pos)
      moves << current_pos

      current_pos = add(current_pos, direction)
    end

    target_color = @board.color_at(current_pos)

    unless target_color.nil? || target_color == @color
      moves << current_pos
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

  private

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

  private

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

  private

  def move_dirs
    [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end
