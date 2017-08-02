require "./circle"
require "./chunk"

class ChunkManager
  alias Point = Tuple(Int32, Int32)

  getter :chunks

  def initialize(@origin : Point, @radius : Int32, @seed = 0_i64)
    @chunks = {} of Point => Chunk
  end

  def update(new_origin)
    @origin = new_origin
    points = Circle.new(@origin, @radius).square

    @chunks = @chunks.select do |point, chunk|
      if points.includes?(point)
        # keep the chunk
        true
      else
        # unload and remove the chunk from our set
        chunk.unload
        false
      end
    end

    points.each do |point|
      if !@chunks.has_key?(point)
        @chunks[point] = Chunk.new({x: point[0], z: point[1]}, @seed)
      end
    end
  end
end
