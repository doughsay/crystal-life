class ChunkMesh
  getter :north, :south, :east, :west, :up, :down

  def initialize
    @north = [] of Chunk::Vec3
    @south = [] of Chunk::Vec3
    @east = [] of Chunk::Vec3
    @west = [] of Chunk::Vec3
    @up = [] of Chunk::Vec3
    @down = [] of Chunk::Vec3
  end

  def generate_faces(chunk : Chunk)
    (-1...128).each do |y|
      (-1...16).each do |x|
        (-1...16).each do |z|
          if chunk.is_solid?({x: x, y: y, z: z})
            if chunk.is_air?({x: x + 1, y: y, z: z})
              @east << {x: x, y: y, z: z}
            end
            if chunk.is_air?({x: x, y: y + 1, z: z})
              @up << {x: x, y: y, z: z}
            end
            if chunk.is_air?({x: x, y: y, z: z + 1})
              @south << {x: x, y: y, z: z}
            end
          else
            if chunk.is_solid?({x: x + 1, y: y, z: z})
              @west << {x: x + 1, y: y, z: z}
            end
            if chunk.is_solid?({x: x, y: y + 1, z: z})
              @down << {x: x, y: y + 1, z: z}
            end
            if chunk.is_solid?({x: x, y: y, z: z + 1})
              @north << {x: x, y: y, z: z + 1}
            end
          end
        end
      end
    end
  end
end
