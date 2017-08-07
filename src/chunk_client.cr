require "socket"

require "./chunk"

class ChunkClient
  alias Point = Tuple(Int32, Int32)

  @chunk : (Chunk | Nil)
  @point : (Point | Nil)

  def initialize
    @client = TCPSocket.new("localhost", 1234)
    @chunk = nil
    @point = nil
  end

  def take
    x = @chunk
    y = @point
    @chunk = nil
    @point = nil
    {x, y}
  end

  def chunk_ready?
    !@chunk.nil?
  end

  def busy?
    false
  end

  def load_chunk(point)
    @point = point
    @client << "#{point[0]},#{point[1]}\n"
    response = @client.gets
    if response
      blocks = response.split(";").each_with_object(Hash(Chunk::Vec3, Block).new) do |pos, blocks|
        x, y, z, m = pos.split(",").map(&.to_i)
        blocks[{x: x, y: y, z: z}] = Block.new(m)
      end
      @chunk = Chunk.new({x: point[0], z: point[1]}, blocks)
    else
      puts "error loading chunk!"
    end
  end
end
