require "./chunk"
require "./chunk_client"
require "./xz"

class ChunkManager
  getter :chunks

  def initialize(@origin : XZ, @radius : Int32)
    @chunks = {} of XZ => Chunk
    @chunks_to_load = Set(XZ).new
    @chunks_to_unload = Set(XZ).new
    @chunk_client = ChunkClient.new
  end

  def origin=(new_origin)
    @origin = new_origin
    points = circle(@origin, @radius)

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
    # chunk is ready to read, read it and add it to chunks (if it's still needed)
    if @chunk_client.chunk_ready?
      # TODO: if it's still needed
      start = GLFW.get_time
      chunk, point = @chunk_client.take
      time = (GLFW.get_time - start) * 1000
      if chunk && point
        @chunks[point] = chunk
      end
    end

    # process the load queue
    unless @chunk_client.busy? || @chunks_to_load.empty?
      point = @chunks_to_load.first
      @chunk_client.load_chunk(point)
      @chunks_to_load.delete(point)
    end

    # process the unload queue
    unless @chunks_to_unload.empty?
      point = @chunks_to_unload.first
      @chunks[point].unload
      @chunks.delete(point)
      @chunks_to_unload.delete(point)
    end

    true
  end

  private def circle(center_point, radius)
    points = Set(XZ).new
    (-@radius..@radius).each do |x|
      (-@radius..@radius).each do |z|
        if x * x + z * z <= @radius * @radius && !(x.abs == @radius && z == 0 || z.abs == @radius && x == 0)
          points.add(@origin + {x, z})
        end
      end
    end
    points
  end
end
