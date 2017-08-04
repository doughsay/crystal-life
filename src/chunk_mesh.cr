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
            if chunk.is_air?({x: x + 1, y: y, z: z}) && x + 1 < 16 && x + 1 != 0
              @east << {x: x, y: y, z: z}
            end
            if chunk.is_air?({x: x, y: y + 1, z: z}) && y + 1 < 128 && y + 1 != 0
              @up << {x: x, y: y, z: z}
            end
            if chunk.is_air?({x: x, y: y, z: z + 1}) && z + 1 < 16 && z + 1 != 0
              @south << {x: x, y: y, z: z}
            end
          else
            if chunk.is_solid?({x: x + 1, y: y, z: z}) && x + 1 < 16 && x + 1 != 0
              @west << {x: x + 1, y: y, z: z}
            end
            if chunk.is_solid?({x: x, y: y + 1, z: z}) && y + 1 < 128 && y + 1 != 0
              @down << {x: x, y: y + 1, z: z}
            end
            if chunk.is_solid?({x: x, y: y, z: z + 1}) && z + 1 < 16 && z + 1 != 0
              @north << {x: x, y: y, z: z + 1}
            end
          end
        end
      end
    end
  end
end
