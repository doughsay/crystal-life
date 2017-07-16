class Cube
  # 4_______5
  # |\      |\
  # | \_____|_\
  # | |6    | |7
  # |_|_____| |
  # \0|     \1|
  #  \|______\|
  #   2       3

  CUBE_SIZE = 0.5_f32
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

  @vao : GL::VertexArray
  @vbo : GL::Buffer
  @ebo : GL::Buffer
  @ibo : GL::Buffer

  def initialize
    @instances = [] of Float32

    # create vertex array object
    @vao = GL.gen_vertex_array
    GL.bind_vertex_array(@vao)

    # generate all needed buffers
    @vbo, @ebo, @ibo = GL.gen_buffers(3)

    # fill the vertex array buffer
    GL.bind_buffer(GL::BufferBindingTarget::ArrayBuffer, @vbo)
    GL.buffer_data(GL::BufferBindingTarget::ArrayBuffer, VERTICES.size * sizeof(Float32), VERTICES, GL::BufferUsage::StaticDraw)

    # set and enable pointer to vertex position data
    GL.vertex_attrib_pointer(0, 3, GL::Type::Float, false, 6 * sizeof(Float32), 0)
    GL.enable_vertex_attrib_array(0)

    # set and enable pointer to vertex color data
    GL.vertex_attrib_pointer(1, 3, GL::Type::Float, false, 6 * sizeof(Float32), 3 * sizeof(Float32))
    GL.enable_vertex_attrib_array(1)

    # fill the index element buffer
    GL.bind_buffer(GL::BufferBindingTarget::ElementArrayBuffer, @ebo)
    GL.buffer_data(GL::BufferBindingTarget::ElementArrayBuffer, INDICES.size * sizeof(UInt32), INDICES, GL::BufferUsage::StaticDraw)

    # fill the instance positions buffer
    GL.bind_buffer(GL::BufferBindingTarget::ArrayBuffer, @ibo)
    # TODO: this buffer is large, but fixed; if more cubes need to be drawn the buffer needs to be resized
    GL.buffer_data(GL::BufferBindingTarget::ArrayBuffer, (2 ** 21) * sizeof(Float32), nil, GL::BufferUsage::StreamDraw)
    # set and enable pointer to instance position data
    GL.vertex_attrib_pointer(2, 3,GL::Type::Float, false, 3 * sizeof(Float32), 0)
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
    GL.bind_buffer(GL::BufferBindingTarget::ArrayBuffer, @ibo)
    GL.buffer_sub_data(GL::BufferBindingTarget::ArrayBuffer, 0, @instances.size * sizeof(Float32), @instances)
  end

  def draw
    return unless @instances.size > 0
    GL.bind_vertex_array(@vao)
    GL.draw_elements_instanced(GL::Primitive::Triangles, INDICES.size, GL::Type::UnsignedInt, 0, @instances.size / 3)
  end

  def delete
    GL.delete_vertex_array(@vao)
    GL.delete_buffers([@vbo, @ebo, @ibo])
  end
end
