class ChunkMesh
  getter :north, :south, :east, :west, :up, :down

  EAST = {1, 0, 0}
  UP = {0, 1, 0}
  SOUTH = {0, 0, 1}

  def initialize
    @north = [] of XYZ
    @south = [] of XYZ
    @east = [] of XYZ
    @west = [] of XYZ
    @up = [] of XYZ
    @down = [] of XYZ
  end

  def generate_faces(chunk : Chunk)
    (-1...128).each do |y|
      (-1...16).each do |x|
        (-1...16).each do |z|
          xyz = XYZ.new(x, y, z)
          if chunk.is_solid?(xyz)
            if chunk.is_air?(xyz + EAST) && x + 1 < 16 && x + 1 != 0
              @east << xyz
            end
            if chunk.is_air?(xyz + UP) && y + 1 < 128 && y + 1 != 0
              @up << xyz
            end
            if chunk.is_air?(xyz + SOUTH) && z + 1 < 16 && z + 1 != 0
              @south << xyz
            end
          else
            if chunk.is_solid?(xyz + EAST) && x + 1 < 16 && x + 1 != 0
              @west << xyz + EAST
            end
            if chunk.is_solid?(xyz + UP) && y + 1 < 128 && y + 1 != 0
              @down << xyz + UP
            end
            if chunk.is_solid?(xyz + SOUTH) && z + 1 < 16 && z + 1 != 0
              @north << xyz + SOUTH
            end
          end
        end
      end
    end
  end
end
