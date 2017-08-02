require "open-simplex-noise"

require "./chunk_mesh"
require "./chunk_renderer"

class Chunk
  alias Vec2 = NamedTuple(x: Int32, z: Int32)
  alias Vec3 = NamedTuple(x: Int32, y: Int32, z: Int32)
  alias Block = Int32

  STONE = Block.new(1)

  getter :coords

  def initialize(@coords : Vec2, @seed = 0_i64)
    @blocks = Hash(Vec3, Block).new
    @noise = OpenSimplexNoise.new(@seed)
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
          height = @noise.generate(x / 64.0, z / 64.0, 0.0, 0.0) * 64 + 64
          @blocks[{x: cx, y: cy, z: cz}] = STONE if y < height
        end
      end
    end
  end
end
