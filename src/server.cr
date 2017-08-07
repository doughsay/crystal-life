require "socket"

require "./server_chunk"
require "./seed"

# the chunk server should respond to requests for chunks by their coords

def handle_connection(socket, client_id, seed, chunks)
  puts "#{client_id}: client connected"
  loop do
    message = socket.gets
    if message
      x, z = message.split(",").map(&.to_i)
      puts "#{client_id}: received #{message}"
      chunk = chunks[{x: x, z: z}] ||= ServerChunk.new({x: x, z: z}, seed)
      socket << chunk.to_response + "\n"
    else
      puts "#{client_id}: client left"
      break
    end
  end
rescue ArgumentError
  puts "#{client_id}: client did a no-no"
end

seed = Seed.new(1234567890_i64)
server = TCPServer.new(1234)
next_client_id = 0
memoized_chunks = {} of NamedTuple(x: Int32, z: Int32) => ServerChunk
loop do
  if socket = server.accept?
    client_id = next_client_id
    next_client_id += 1
    spawn handle_connection(socket, client_id, seed, memoized_chunks)
  else
    break
  end
end
