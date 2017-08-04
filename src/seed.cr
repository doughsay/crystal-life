class Seed
  getter :noise

  def initialize(@seed : Int64)
    @noise = OpenSimplexNoise.new(@seed)
  end
end
