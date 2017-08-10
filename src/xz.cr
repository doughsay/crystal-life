require "cannon"

@[Packed]
struct XZ
  include Cannon::FastAuto

  getter x, z

  def initialize(@x : Int32, @z : Int32)
  end

  def +(other : Tuple(Int32, Int32))
    XZ.new(x + other[0], z + other[1])
  end

  def +(other : XZ)
    XZ.new(x + other.x, z + other.z)
  end

  def to_s
    "{#{x}, #{z}}"
  end

  def to_s(io)
    io << to_s
  end

  def inspect
    to_s
  end
end
