class Pawn < Piece
  def initialize(pos, color, board)
    super
    @moved = false
    @icon = '♙' if color == :white
    @icon = '♟' if color == :black
    @value = 1
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
