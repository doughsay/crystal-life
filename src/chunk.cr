require "./chunk_mesh"
require "./chunk_renderer"
require "./xyz"

class Chunk
  getter :coords

  def initialize(@coords : XZ, @blocks : Hash(XYZ, Int32))
    @mesh = ChunkMesh.new
    @renderer = ChunkRenderer.new

    @mesh.generate_faces(self)
    @renderer.load_faces(@mesh)
  end

  def is_solid?(pos : XYZ)
    @blocks.has_key?(pos)
  end

  def is_air?(pos : XYZ)
    !is_solid?(pos)
  end

  def render
    @renderer.draw
  end

  def unload
    @renderer.delete
  end
end
