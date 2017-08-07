require "./chunk_mesh"
require "./chunk_renderer"
require "./block"

class Chunk
  alias Vec2 = NamedTuple(x: Int32, z: Int32)
  alias Vec3 = NamedTuple(x: Int32, y: Int32, z: Int32)

  getter :coords

  def initialize(@coords : Vec2, @blocks : Hash(Vec3, Block))
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
end
