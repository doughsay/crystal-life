require "./chunk_mesh"
require "./chunk_renderer"

class Chunk
  alias Vec2 = NamedTuple(x: Int32, z: Int32)
  alias Vec3 = NamedTuple(x: Int32, y: Int32, z: Int32)
  alias Block = Int32

  STONE = Block.new(1)

  def initialize(@coords : Vec2)
    @blocks = Hash(Vec3, Block).new
    populate_from_noise
    @mesh = ChunkMesh.new
    @renderer = ChunkRenderer.new

    @mesh.generate_faces(self)
    @renderer.load_faces(@mesh)
  end

  def is_solid?(pos : Vec3)
    @blocks.has_key?(pos)
  end

  def is_air?(pos : Vec3)
    !is_solid?(pos)
  end

  def render
    @renderer.draw
  end

  def unload
    @renderer.delete
  end

  private def populate_from_noise
    (0...128).each do |cy|
      (0...16).each do |cz|
        (0...16).each do |cx|
          x = cx + (@coords[:x] * 16)
          y = cy
          z = cz + (@coords[:z] * 16)
          if Noise.generate(x / 30.0, y / 30.0, z / 30.0) > 0.05
            @blocks[{x: cx, y: cy, z: cz}] = STONE
          end
        end
      end
    end
  end
end
