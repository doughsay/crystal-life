struct Point
  getter x, y, z

  def initialize(@x : Int32, @y : Int32, @z : Int32)
  end

  def neighbor(direction : Direction)
    case direction
    when Direction::North
      Point.new(self.x, self.y, self.z - 1)
    when Direction::South
      Point.new(self.x, self.y, self.z + 1)
    when Direction::East
      Point.new(self.x + 1, self.y, self.z)
    when Direction::West
      Point.new(self.x - 1, self.y, self.z)
    when Direction::Up
      Point.new(self.x, self.y + 1, self.z)
    when Direction::Down
      Point.new(self.x, self.y - 1, self.z)
    end
  end
end
