class Board
  attr_reader :grid
  def initialize(size = 9)
    @grid = Array.new(size) {Array.new(size)}
  end

end
