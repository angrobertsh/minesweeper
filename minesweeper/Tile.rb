class Tile
  attr_reader :value, :state

  def initialize(value = "")
    @state = ""
    @value = value
  end

  def flip
    @state = "flipped"
  end

  def flag
    @state = "flagged"
  end

end
