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

    # for all currently loaded chunks
    # if the chunk is no longer in view
    # add it to the unload queue
    @chunks.keys.each do |point|
      if !points.includes?(point)
        @chunks_to_unload.add(point)
      end
    end

    # for all chunks currently in the load queue
    # remove the ones that are no longer in view
    @chunks_to_load.each do |point|
      if !points.includes?(point)
        @chunks_to_load.delete(point)
      end
    end

    # for all points now in view
    points.each do |point|

      # if the chunk is not yet loaded
      # add it to the load queue
      if !@chunks.has_key?(point)
        @chunks_to_load.add(point)
      end

      # if the chunk is scheduled to be unloaded
      # don't unload it anymore
      if @chunks_to_unload.includes?(point)
        @chunks_to_unload.delete(point)
      end
    end

  end

  def update
    # process the load queue one at a time
    unless @chunks_to_load.empty?
      point = @chunks_to_load.first
      @chunks[point] = Chunk.new({x: point[0], z: point[1]}, @seed)
      @chunks_to_load.delete(point)
      return true
    end

    # process the unload queue one at a time
    unless @chunks_to_unload.empty?
      point = @chunks_to_unload.first
      @chunks[point].unload
      @chunks.delete(point)
      @chunks_to_unload.delete(point)
      return true
    end

    false
  end
end
