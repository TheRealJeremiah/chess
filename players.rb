class HumanPlayer
  attr_accessor :color

  def input(board)
    parse(gets.chomp)
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

class ComputerPlayer
  attr_accessor :color

  def input(board)
    @squares = board.squares

    if all_captures.empty?
      all_possible_moves.sample
    else
      sort_captures.first
    end
  end

  # def current_pieces
  #   @squares.flatten.compact.select {|piece| piece.color == @color}
  # end
  #
  # def all_possible_moves
  #   moves = []
  #   current_pieces.each do |piece|
  #     from = piece.pos
  #     piece.possible_moves.each do |move|
  #       to = move
  #       moves << [from, to]
  #     end
  #   end
  #   moves
  # end
  #
  # def all_captures
  #   all_possible_moves.select do |(from, to)|
  #    !@squares[to[0]][to[1]].nil?
  #   end
  # end
  #
  # def sort_captures
  #   all_captures.sort_by { |(from, to)| @squares[to[0]][to[1]].value }
  # end
end


class BoardNode
  MAX_DEPTH = 3
  attr_reader :children, :value
  def initialize(board, color, depth, value)
    @board = board
    @depth = depth
    @color = color
    @value = value
    @children = []
    make_children
  end

  def dfs
    if @children.empty?
      return @value
    end
    child_vals = []
    if @depth.even?
      @children.each do |child|
        child_vals << child.dfs
      end
      return @value + child_vals.max
    else
      @children.each do |child|
        child_vals << child.dfs
      end
      return @value + child_vals.min
    end
  end

  def make_children
    return nil if @depth == MAX_DEPTH
    all_possible_moves.each do |move|
      new_board = @board.dup
      begin
        # val = 0
        from, to = move
        row, col = move[1]
        piece = new_board.squares[row][col]
        # val = piece.value unless piece.nil?
        new_board.move(from, to)
        value = find_value(move)
        @children << BoardNode.new(new_board, opposite_color(@color), @depth + 1, value)
      rescue
        next
      end
    end
  end

  def find_value(move)
    row, col = move[1]
    piece = @board.squares[row][col]

    return 0 if piece.nil?

    @depth.even? ? piece.value : piece.value * -1
  end

  def current_pieces
    @board.squares.flatten.compact.select {|piece| piece.color == @color}
  end

  def all_possible_moves
    moves = []
    current_pieces.each do |piece|
      from = piece.pos
      piece.possible_moves.each do |move|
        to = move
        moves << [from, to]
      end
    end
    moves
  end

  def all_captures
    all_possible_moves.select do |(from, to)|
     !@board.squares[to[0]][to[1]].nil?
    end
  end

  def sort_captures
    all_captures.sort_by { |(from, to)| @board.squares[to[0]][to[1]].value }
  end

  def opposite_color(color)
    color == :white ? :black : :white
  end
end
