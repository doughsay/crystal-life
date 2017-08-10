require "socket"
require "cannon"

require "./server_chunk"
require "./seed"
require "./xz"

# the chunk server should respond to requests for chunks by their coords

def handle_connection(socket, client_id, seed, chunks)
  puts "#{client_id}: client connected"
  loop do
    coord = Cannon.decode(socket, XZ)
    chunk = chunks[coord] ||= ServerChunk.new(coord, seed)
    Cannon.encode(socket, chunk.blocks)
  end
rescue IO::EOFError
  puts "#{client_id}: client left"
end

seed = Seed.new(1234567890_i64)
server = TCPServer.new(1234)
next_client_id = 0
memoized_chunks = {} of XZ => ServerChunk
loop do
  if socket = server.accept?
    client_id = next_client_id
    next_client_id += 1
    spawn handle_connection(socket, client_id, seed, memoized_chunks)
  else
    break
  end
end
