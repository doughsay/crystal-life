class Circle
  alias Point = Tuple(Int32, Int32)

  def initialize(@origin : Point, @radius : Int32)
  end

  def square
    points = [] of Point
    (-@radius..@radius).each do |x|
      (-@radius..@radius).each do |y|
        if x * x + y * y <= @radius * @radius
          points << {@origin[0] + x, @origin[1] + y} unless x.abs == @radius && y == 0 || y.abs == @radius && x == 0
        end
      end
    end
    points
  end

  def midpoint
    points = Set(Point).new

    x = @radius - 1
    y = 0
    dx = 1
    dy = 1
    err = dx - (@radius << 1)

    while (x >= y)
      points << {@origin[0] + x, @origin[1] + y}
      points << {@origin[0] + y, @origin[1] + x}
      points << {@origin[0] - y, @origin[1] + x}
      points << {@origin[0] - x, @origin[1] + y}
      points << {@origin[0] - x, @origin[1] - y}
      points << {@origin[0] - y, @origin[1] - x}
      points << {@origin[0] + y, @origin[1] - x}
      points << {@origin[0] + x, @origin[1] - y}

      if (err <= 0)
        y += 1
        err += dy
        dy +=2
      else
        x -= 1
        dx += 2
        err += (-@radius << 1) + dx
      end
    end

    points
  end
end
