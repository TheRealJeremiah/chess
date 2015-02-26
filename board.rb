class Board
  attr_reader :squares

  def initialize
    @squares = Array.new(8) { Array.new(8) }
    set_pieces
  end

  def display
    puts "\n  a b c d e f g h"
    @squares.each_with_index do |row, idx|
      string = (8-idx).to_s + " "
      row.each_with_index do |col, idy|
        color = (idx + idy).even? ? :light_blue : :white
        if col.nil?
          string += " ".colorize(:color => :black, :background => color)
        else
          string += col.icon.colorize(:color => :black, :background => color)
        end
        string += " ".colorize(:color => :black, :background => color)
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
      new_board = self.dup
      new_board.set_square(to, piece.dup(new_board))
      new_board.set_square(from, nil)
      if new_board.check?(piece.color)
        raise ArgumentError.new("That puts you in check!")
      end
      @squares[row2][col2] = @squares[row1][col1]
      @squares[row1][col1] = nil
      @squares[row2][col2].move_to(to)
    else
      raise ArgumentError.new("That piece cannot make that move!")
    end
  end

  def check_mate?(color)
    pieces = @squares.flatten.compact.select{|piece| piece.color == color}
    pieces.each do |piece|
      piece.possible_moves.each do |to|
        new_board = self.dup
        new_board.set_square(to, piece)
        new_board.set_square(piece.pos, nil)

        if !new_board.check?(color)
          return false
        end
      end
    end

    true
  end

  def dup
    new_board = Board.new

    @squares.each_with_index do |row, row_num|
      row.each_with_index do |square, col_num|
        if !square.nil?
          new_board.set_square([row_num, col_num], square.dup(new_board))
        else
          new_board.set_square([row_num, col_num], nil)
        end
      end
    end

    new_board
  end

  def check_turn(from, color)
    row, col = from
    @squares[row][col].color == color
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

  protected

  def set_square(loc, piece)
    @squares[loc[0]][loc[1]] = piece
  end

  def check?(color)
    king_pos = nil
    opp_moves = []

    @squares.each_with_index do |row, row_num|
      row.each_with_index do |piece, col_num|
        if piece.is_a?(King) && piece.color == color
          king_pos = [row_num, col_num]
        elsif !piece.nil? && piece.color != color
          opp_moves += piece.possible_moves
        end
      end
    end

    opp_moves.include?(king_pos)
  end

  private

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


  def off_board?(pos)
    row, col = pos
    row < 0 || row > 7 || col < 0 || col > 7
  end
end
