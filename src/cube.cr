class Cube
  # 4_______5
  # |\      |\
  # | \_____|_\
  # | |6    | |7
  # |_|_____| |
  # \0|     \1|
  #  \|______\|
  #   2       3

  CUBE_SIZE = 0.45_f32
  VERTICES = [
    # positions                          # colors
    -CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE,  0.4_f32, 0.4_f32, 0.4_f32,  # 0
     CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE,  0.2_f32, 0.2_f32, 0.2_f32,  # 1
    -CUBE_SIZE, -CUBE_SIZE,  CUBE_SIZE,  0.6_f32, 0.6_f32, 0.6_f32,  # 2
     CUBE_SIZE, -CUBE_SIZE,  CUBE_SIZE,  0.4_f32, 0.4_f32, 0.4_f32,  # 3
    -CUBE_SIZE,  CUBE_SIZE, -CUBE_SIZE,  0.6_f32, 0.6_f32, 0.6_f32,  # 4
     CUBE_SIZE,  CUBE_SIZE, -CUBE_SIZE,  0.4_f32, 0.4_f32, 0.4_f32,  # 5
    -CUBE_SIZE,  CUBE_SIZE,  CUBE_SIZE,  1.0_f32, 1.0_f32, 1.0_f32,  # 6
     CUBE_SIZE,  CUBE_SIZE,  CUBE_SIZE,  0.6_f32, 0.6_f32, 0.6_f32   # 7
  ]
  NUM_VERTICES = VERTICES.size
  VERTEX_SIZE = sizeof(Float32)
  VERTICES_SIZE = VERTEX_SIZE * NUM_VERTICES
  STRIDE = 6 * VERTEX_SIZE
  VERTEX_OFFSET = Offset.new(0)
  COLOR_OFFSET = Offset.new(3 * VERTEX_SIZE)

  INDICES = [
    4_u32, 5_u32, 1_u32,
    4_u32, 1_u32, 0_u32,
    5_u32, 7_u32, 3_u32,
    5_u32, 3_u32, 1_u32,
    7_u32, 6_u32, 2_u32,
    7_u32, 2_u32, 3_u32,
    6_u32, 4_u32, 0_u32,
    6_u32, 0_u32, 2_u32,
    0_u32, 1_u32, 3_u32,
    0_u32, 3_u32, 2_u32,
    6_u32, 7_u32, 5_u32,
    6_u32, 5_u32, 4_u32
  ]
  NUM_INDICES = INDICES.size
  INDEX_SIZE = sizeof(UInt32)
  INDICES_SIZE = INDEX_SIZE * NUM_INDICES
  INDEX_OFFSET = Offset.new(0)

  alias Offset = Pointer(Void)

  def initialize(@instances = [] of Float32)
    # create vertex array object
    GL.gen_vertex_arrays(1, out @vao)
    GL.bind_vertex_array(@vao)

    # create and fill vertex array buffer
    GL.gen_buffers(1, out @vbo)
    GL.bind_buffer(GL::ARRAY_BUFFER, @vbo)
    GL.buffer_data(GL::ARRAY_BUFFER, VERTICES_SIZE, VERTICES, GL::STATIC_DRAW)
    # set and enable pointer to vertex position data
    GL.vertex_attrib_pointer(0, 3, GL::FLOAT, GL::FALSE, STRIDE, VERTEX_OFFSET)
    GL.enable_vertex_attrib_array(0)
    # set and enable pointer to vertex color data
    GL.vertex_attrib_pointer(1, 3, GL::FLOAT, GL::FALSE, STRIDE, COLOR_OFFSET)
    GL.enable_vertex_attrib_array(1)

    # create and fill the index element buffer
    GL.gen_buffers(1, out @ebo)
    GL.bind_buffer(GL::ELEMENT_ARRAY_BUFFER, @ebo)
    GL.buffer_data(GL::ELEMENT_ARRAY_BUFFER, INDICES_SIZE, INDICES, GL::STATIC_DRAW)

    # create the instance positions buffer
    GL.gen_buffers(1, out @ibo)
    GL.bind_buffer(GL::ARRAY_BUFFER, @ibo)
    # set and enable pointer to instance position data
    GL.vertex_attrib_pointer(2, 3, GL::FLOAT, GL::FALSE, 3 * sizeof(Float32), Offset.new(0))
    GL.vertex_attrib_divisor(2, 1)
    GL.enable_vertex_attrib_array(2)
  end

  def load_instances(points : Array(Point))
    @instances = Array(Float32).build(3 * points.size) do |buffer|
      i = 0
      points.each do |point|
        buffer[i] = point.x.to_f32
        buffer[i+1] = point.y.to_f32
        buffer[i+2] = point.z.to_f32
        i += 3
      end
      3 * points.size
    end
    GL.bind_buffer(GL::ARRAY_BUFFER, @ibo)
    GL.buffer_data(GL::ARRAY_BUFFER, @instances.size * sizeof(Float32), @instances, GL::DYNAMIC_DRAW)
  end

  def draw
    return unless @instances.size > 0
    GL.bind_vertex_array(@vao)
    GL.draw_elements_instanced(GL::TRIANGLES, NUM_INDICES, GL::UNSIGNED_INT, INDEX_OFFSET, @instances.size / 3)
  end

  def delete
    GL.delete_vertex_arrays(1, pointerof(@vao))
    GL.delete_buffers(1, pointerof(@vbo))
    GL.delete_buffers(1, pointerof(@ebo))
    GL.delete_buffers(1, pointerof(@ibo))
  end
end
