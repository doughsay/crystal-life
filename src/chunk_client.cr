require "socket"

require "./chunk"

class ChunkClient
  alias Point = Tuple(Int32, Int32)

  @chunk : (Chunk | Nil)
  @point : (Point | Nil)

  def initialize
    # puts "chunk manager: initializing"
    @input_channel = Channel(Point).new(1)
    @output_channel = Channel(Chunk).new(1)
    @point = nil
    @busy = false
    spawn socket_loop(@input_channel, @output_channel)
  end

  def take
    # puts "chunk manager: taking #{@point}"
    x = @output_channel.receive
    y = @point
    @point = nil
    @busy = false
    {x, y}
  end

  def chunk_ready?
    # puts "chunk manager: chunk_ready? #{!@output_channel.empty?}"
    !@output_channel.empty?
  end

  def busy?
    # puts "chunk manager: busy? #{@busy}"
    @busy
  end

  def load_chunk(point)
    # puts "chunk manager: load_chunk #{point}"
    raise "nope" if @busy

    @point = point
    @busy = true
    @input_channel.send(point)
  end

  def socket_loop(input, output)
    # puts "chunk manager: socket loop starting"
    client = TCPSocket.new("localhost", 1234)

    # puts "chunk manager: connected, starting loop"
    loop do
      point = input.receive
      # puts "chunk manager: got point #{point}"
      client << "#{point[0]},#{point[1]}\n"
      # puts "chunk manager: sent point to server"
      response = client.gets
      # puts "chunk manager: got response from server"
      if response
        start = GLFW.get_time

        blocks = response.split(";").each_with_object(Hash(Chunk::Vec3, Block).new) do |pos, blocks|
          x, y, z, m = pos.split(",").map(&.to_i)
          blocks[{x: x, y: y, z: z}] = Block.new(m)
        end
        time = (GLFW.get_time - start) * 1000
        puts "chunk took #{time} to be decoded"

        chunk = Chunk.new({x: point[0], z: point[1]}, blocks)
        # puts "chunk manager: sending chunk to output channel"

        time = (GLFW.get_time - start) * 1000
        puts "chunk took #{time} to be initialized"

        output.send(chunk)
      else
        # puts "error loading chunk!"
      end
    end
  end
end
