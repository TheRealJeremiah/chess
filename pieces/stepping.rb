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

  private

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

  private

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

  private

  def moves
    [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end
