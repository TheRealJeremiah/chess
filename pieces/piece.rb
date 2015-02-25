class Piece
  attr_reader :color, :icon, :pos

  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board
  end

  def possible_moves
    raise NotImplementedError.new("Moves not implemented")
  end

  def move_to(pos)
    @pos = pos
  end

  def dup(board)
    self.class.new(@pos.dup, @color, board)
  end

  protected

  def add(pos, dir)
    [(pos[0] + dir[0]), (pos[1] + dir[1])]
  end
end
