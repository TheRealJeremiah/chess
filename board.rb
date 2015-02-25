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
