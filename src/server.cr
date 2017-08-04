require "socket"

require "./server_chunk"
require "./seed"

# the chunk server should respond to requests for chunks by their coords

def handle_connection(socket, client_id, seed)
  puts "#{client_id}: client connected"
  loop do
    message = socket.gets
    if message
      x, z = message.split(",").map(&.to_i)
      puts "#{client_id}: received #{message}"
      socket << ServerChunk.new({x: x, z: z}, seed).to_response
    else
      puts "#{client_id}: client left"
      break
    end
  end
rescue ArgumentError
  puts "client did a no-no"
end

seed = Seed.new(1234567890_i64)
server = TCPServer.new(1234)
next_client_id = 0
loop do
  if socket = server.accept?
    client_id = next_client_id
    next_client_id += 1
    spawn handle_connection(socket, client_id, seed)
  else
    break
  end
end
