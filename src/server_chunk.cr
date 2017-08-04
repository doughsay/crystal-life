require "open-simplex-noise"

require "./block"

class ServerChunk
  alias Vec2 = NamedTuple(x: Int32, z: Int32)
  alias Vec3 = NamedTuple(x: Int32, y: Int32, z: Int32)

  @noise : OpenSimplexNoise

  def initialize(@coords : Vec2, @seed : Seed)
    @blocks = Hash(Vec3, Block).new
    @noise = @seed.noise
    populate_from_noise
  end

  def to_response
    @blocks.map do |point, material|
      "#{point[:x]},#{point[:y]},#{point[:z]},#{material.to_i}"
    end.join(";")
  end

  private def populate_from_noise
    (0...128).each do |cy|
      (0...16).each do |cz|
        (0...16).each do |cx|
          x = cx + (@coords[:x] * 16)
          y = cy
          z = cz + (@coords[:z] * 16)
          height = @noise.generate(x / 64.0, z / 64.0, 0.0, 0.0) * 64 + 64
          # height = 96
          @blocks[{x: cx, y: cy, z: cz}] = Block::Stone if y < height
        end
      end
    end
  end
end
