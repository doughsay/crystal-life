require "open-simplex-noise"

require "./xz"
require "./xyz"

class ServerChunk
  @noise : OpenSimplexNoise
  getter :blocks

  def initialize(@coords : XZ, @seed : Seed)
    @blocks = Hash(XYZ, Int32).new
    @noise = @seed.noise
    populate_from_noise
  end

  private def populate_from_noise
    (0...128).each do |cy|
      (0...16).each do |cz|
        (0...16).each do |cx|
          x = cx + (@coords.x * 16)
          y = cy
          z = cz + (@coords.z * 16)
          height = @noise.generate(x / 64.0, z / 64.0, 0.0, 0.0) * 64 + 64
          # height = 96
          @blocks[XYZ.new(cx, cy, cz)] = 1 if y < height
        end
      end
    end
  end
end
