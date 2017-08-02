require "./circle"
require "./chunk"

class ChunkManager
  alias Point = Tuple(Int32, Int32)

  getter :chunks

  def initialize(@origin : Point, @radius : Int32, @seed = 0_i64)
    @chunks = {} of Point => Chunk
    @chunks_to_load = Set(Point).new
    @chunks_to_unload = Set(Point).new
  end

  def origin=(new_origin)
    @origin = new_origin
    points = Circle.new(@origin, @radius).square

    @chunks.each do |point, chunk|
      if !points.includes?(point)
        @chunks_to_unload.add(point)
      end
    end

    points.each do |point|
      if !@chunks.has_key?(point)
        @chunks_to_load.add(point)
      end
    end
  end

  def update
    unless @chunks_to_unload.empty?
      point = @chunks_to_unload.first
      @chunks[point].unload
      @chunks.delete(point)
      @chunks_to_unload.delete(point)
      return true
    end

    unless @chunks_to_load.empty?
      point = @chunks_to_load.first
      @chunks[point] = Chunk.new({x: point[0], z: point[1]}, @seed)
      @chunks_to_load.delete(point)
      return true
    end

    false
  end
end
