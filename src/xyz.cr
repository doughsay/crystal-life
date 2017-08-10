require "cannon"

@[Packed]
struct XYZ
  include Cannon::FastAuto

  getter x, y, z

  def initialize(@x : Int32, @y : Int32, @z : Int32)
  end

  def +(other : Tuple(Int32, Int32, Int32))
    XYZ.new(x + other[0], y + other[1], z + other[2])
  end

  def +(other : XYZ)
    XYZ.new(x + other.x, y + other.y, z + other.z)
  end

  def to_s
    "{#{x}, #{y}, #{z}}"
  end

  def to_s(io)
    io << to_s
  end

  def inspect
    to_s
  end
end
