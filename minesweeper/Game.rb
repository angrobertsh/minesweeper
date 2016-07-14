require_relative 'Board'
require_relative 'Tile'

class Game

  attr_reader :board, :lose

  def initialize()
    @board = Board.new(10).grid
    @lose = false
  end

  def populate
    place_bombs(rand(@board.size*@board.size))
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
    r, c = pos
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
            print "#{el.value} "
        end
      end
      puts
    end
    puts
  end

  def play
    populate
    system("clear")
    render
    until won? || @lose
      position = get_pos
      option = get_option
      flip(position) if option == "flip"
      flag(position) if option == "flag"
      system("clear")
      render
    end
    puts "You lose" if @lose
    puts "You win!" if won?
  end

  def get_pos
    puts "What coordinate do you want?(a,b)"
    position = gets.chomp.split(",").map(&:to_i)
    until position[0] < @board.size && position[1] < @board.size && position.length==2
      puts "Please enter the coordinates as (a,b)"
      position = (gets.chomp).split(",").map(&:to_i)
    end
    position
  end

  def get_option
    puts "Do you want to flip or flag?"
    option = gets.chomp.downcase
    until option=="flag" || option=="flip"
      puts "Please enter 'flag' or 'flip'"
      option = gets.chomp.downcase
    end
    option
  end

  def flip(pos)
    @board[pos[0]][pos[1]].flip
    @lose = true if @board[pos[0]][pos[1]].value == "B"
  end

  def flag(pos)
    target = @board[pos[0]][pos[1]]
    target.flag unless target.state == "flipped"
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
