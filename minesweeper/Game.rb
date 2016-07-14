require_relative 'Board'
require_relative 'Tile'

class Game

  attr_reader :board, :lose

  def initialize()
    @board = Board.new.grid
    @lose = false
  end

  def populate
    place_bombs(9)
    place_nums
  end

  def place_bombs(num)
    count_bomb = 0
    while count_bomb < num
      a = rand(@board.length)
      b = rand(@board.length)
      if @board[a][b].nil?
        @board[a][b] = Tile.new("B")
        count_bomb+=1
      end
    end
  end

  def calc_nums(pos)
    r = pos[0]
    c = pos[1]
    count = 0
    (-1..1).each do |row|
      (-1..1).each do |col|
        if @board[r+row].nil? || @board[r+row][c+col].nil?
          next
        elsif r + row < 0 || c + col < 0
          next
        else
          count+=1 if @board[r+row][c+col].value == "B"
        end
      end
    end
    count
  end

  def place_nums
    @board.each_with_index do |row, i|
      row.each_with_index do |el, j|
        @board[i][j] = Tile.new(calc_nums([i,j]).to_s) if el.nil?
      end
    end
  end

  def render
    puts
    @board.each do |row|
      row.each do |el|
        if el.state == "flagged"
          print "F "
        elsif el.state == ""
          print "* "
        else
#          if el.nil?
#            print "nil "
#          else
            print "#{el.value} "
#          end
        end
      end
      puts
    end
    puts
  end

  def play
    populate
    render
    until won? || @lose
      puts "What coordinate do you want?(a,b)"
      position = (gets.chomp).split(",").map(&:to_i)
      puts "Do you want to flip or flag?"
      option = gets.chomp.downcase
      flip(position) if option == "flip"
      flag(position) if option == "flag"
      render
    end
    puts "You lose" if @lose
    puts "You win!" if won?

  end

  def flip(pos)
    @board[pos[0]][pos[1]].flip
    @lose = true if @board[pos[0]][pos[1]].value == "B"
  end

  def flag(pos)
    @board[pos[0]][pos[1]].flag
  end

  

  def won?
    count = 0
    total = @board.length * @board[0].length
    @board.each { |row| row.each {|el| count+=1 if el.state == "flipped"}}
    return true if count == total
    false
  end

end

game = Game.new
game.play
