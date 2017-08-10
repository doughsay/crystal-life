require "socket"
require "cannon"

require "./chunk"
require "./xz"

class ChunkClient
  @chunk : (Chunk | Nil)
  @point : (XZ | Nil)

  def initialize
    @input_channel = Channel(XZ).new(1)
    @output_channel = Channel(Chunk).new(1)
    @point = nil
    @busy = false
    spawn socket_loop(@input_channel, @output_channel)
  end

  def take
    chunk = @output_channel.receive
    point = @point
    @point = nil
    @busy = false

    {chunk, point}
  end

  def chunk_ready?
    !@output_channel.empty?
  end

  def busy?
    @busy
  end

  def load_chunk(point)
    raise "nope" if @busy

    @point = point
    @busy = true
    @input_channel.send(point)
  end

  def socket_loop(input, output)
    client = TCPSocket.new("localhost", 1234)

    loop do
      point = input.receive
      Cannon.encode(client, point)
      blocks = Cannon.decode(client, Hash(XYZ, Int32))
      chunk = Chunk.new(point, blocks)

      output.send(chunk)
    end
  end
end
