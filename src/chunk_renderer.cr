class ChunkRenderer
  # 4_______5
  # |\      |\
  # | \_____|_\
  # | |6    | |7
  # |_|_____| |
  # \0|     \1|
  #  \|______\|
  #   2       3

  North = Direction::North
  South = Direction::South
  East = Direction::East
  West = Direction::West
  Up = Direction::Up
  Down = Direction::Down

  MAX_INSTANCES = 16_384

  VERTICES = {
    North => [
      # position                  normal
      1.0_f32, 0.0_f32, 0.0_f32,  0.0_f32, 0.0_f32, -1.0_f32,  # 1
      0.0_f32, 1.0_f32, 0.0_f32,  0.0_f32, 0.0_f32, -1.0_f32,  # 4
      1.0_f32, 1.0_f32, 0.0_f32,  0.0_f32, 0.0_f32, -1.0_f32,  # 5
      1.0_f32, 0.0_f32, 0.0_f32,  0.0_f32, 0.0_f32, -1.0_f32,  # 1
      0.0_f32, 0.0_f32, 0.0_f32,  0.0_f32, 0.0_f32, -1.0_f32,  # 0
      0.0_f32, 1.0_f32, 0.0_f32,  0.0_f32, 0.0_f32, -1.0_f32   # 4
    ],
    South => [
      # position                  normal
      0.0_f32, 0.0_f32, 1.0_f32,  0.0_f32, 0.0_f32, 1.0_f32,  # 2
      1.0_f32, 1.0_f32, 1.0_f32,  0.0_f32, 0.0_f32, 1.0_f32,  # 7
      0.0_f32, 1.0_f32, 1.0_f32,  0.0_f32, 0.0_f32, 1.0_f32,  # 6
      0.0_f32, 0.0_f32, 1.0_f32,  0.0_f32, 0.0_f32, 1.0_f32,  # 2
      1.0_f32, 0.0_f32, 1.0_f32,  0.0_f32, 0.0_f32, 1.0_f32,  # 3
      1.0_f32, 1.0_f32, 1.0_f32,  0.0_f32, 0.0_f32, 1.0_f32   # 7
    ],
    East => [
      # position                  normal
      1.0_f32, 0.0_f32, 1.0_f32,  1.0_f32, 0.0_f32, 0.0_f32,  # 3
      1.0_f32, 1.0_f32, 0.0_f32,  1.0_f32, 0.0_f32, 0.0_f32,  # 5
      1.0_f32, 1.0_f32, 1.0_f32,  1.0_f32, 0.0_f32, 0.0_f32,  # 7
      1.0_f32, 0.0_f32, 1.0_f32,  1.0_f32, 0.0_f32, 0.0_f32,  # 3
      1.0_f32, 0.0_f32, 0.0_f32,  1.0_f32, 0.0_f32, 0.0_f32,  # 1
      1.0_f32, 1.0_f32, 0.0_f32,  1.0_f32, 0.0_f32, 0.0_f32   # 5
    ],
    West => [
      # position                  normal
      0.0_f32, 0.0_f32, 0.0_f32,  -1.0_f32, 0.0_f32, 0.0_f32,  # 0
      0.0_f32, 1.0_f32, 1.0_f32,  -1.0_f32, 0.0_f32, 0.0_f32,  # 6
      0.0_f32, 1.0_f32, 0.0_f32,  -1.0_f32, 0.0_f32, 0.0_f32,  # 4
      0.0_f32, 0.0_f32, 0.0_f32,  -1.0_f32, 0.0_f32, 0.0_f32,  # 0
      0.0_f32, 0.0_f32, 1.0_f32,  -1.0_f32, 0.0_f32, 0.0_f32,  # 2
      0.0_f32, 1.0_f32, 1.0_f32,  -1.0_f32, 0.0_f32, 0.0_f32   # 6
    ],
    Up => [
      # position                  normal
      0.0_f32, 1.0_f32, 1.0_f32,  0.0_f32, 1.0_f32, 0.0_f32,  # 6
      1.0_f32, 1.0_f32, 1.0_f32,  0.0_f32, 1.0_f32, 0.0_f32,  # 7
      1.0_f32, 1.0_f32, 0.0_f32,  0.0_f32, 1.0_f32, 0.0_f32,  # 5
      0.0_f32, 1.0_f32, 1.0_f32,  0.0_f32, 1.0_f32, 0.0_f32,  # 6
      1.0_f32, 1.0_f32, 0.0_f32,  0.0_f32, 1.0_f32, 0.0_f32,  # 5
      0.0_f32, 1.0_f32, 0.0_f32,  0.0_f32, 1.0_f32, 0.0_f32   # 4
    ],
    Down => [
      # position                  normal
      0.0_f32, 0.0_f32, 0.0_f32,  0.0_f32, -1.0_f32, 0.0_f32,  # 0
      1.0_f32, 0.0_f32, 0.0_f32,  0.0_f32, -1.0_f32, 0.0_f32,  # 1
      1.0_f32, 0.0_f32, 1.0_f32,  0.0_f32, -1.0_f32, 0.0_f32,  # 3
      0.0_f32, 0.0_f32, 0.0_f32,  0.0_f32, -1.0_f32, 0.0_f32,  # 0
      1.0_f32, 0.0_f32, 1.0_f32,  0.0_f32, -1.0_f32, 0.0_f32,  # 3
      0.0_f32, 0.0_f32, 1.0_f32,  0.0_f32, -1.0_f32, 0.0_f32   # 2
    ]
  }

  @vertex_array_objects : Hash(Direction, GL::VertexArray)
  @vertex_buffer_objects : Hash(Direction, GL::Buffer)
  @instance_buffer_objects : Hash(Direction, GL::Buffer)
  @instances : Hash(Direction, Array(Float32))

  def initialize
    @instances = {
      North => ([] of Float32),
      South => ([] of Float32),
      East => ([] of Float32),
      West => ([] of Float32),
      Up => ([] of Float32),
      Down => ([] of Float32)
    }

    # generate vertex array objects
    vao_n, vao_s, vao_e, vao_w, vao_u, vao_d = GL.gen_vertex_arrays(6)

    @vertex_array_objects = {
      North => vao_n,
      South => vao_s,
      East => vao_e,
      West => vao_w,
      Up => vao_u,
      Down => vao_d
    }

    # generate all needed buffers
    vbo_n, ibo_n, vbo_s, ibo_s, vbo_e, ibo_e, vbo_w, ibo_w, vbo_u, ibo_u, vbo_d, ibo_d = GL.gen_buffers(12)

    @vertex_buffer_objects = {
      North => vbo_n,
      South => vbo_s,
      East => vbo_e,
      West => vbo_w,
      Up => vbo_u,
      Down => vbo_d
    }

    @instance_buffer_objects = {
      North => ibo_n,
      South => ibo_s,
      East => ibo_e,
      West => ibo_w,
      Up => ibo_u,
      Down => ibo_d
    }

    # set up all objects
    gen(North)
    gen(South)
    gen(East)
    gen(West)
    gen(Up)
    gen(Down)
  end

  def load_faces(mesh : ChunkMesh)
    load_direction_instances(North, mesh.north)
    load_direction_instances(South, mesh.south)
    load_direction_instances(East, mesh.east)
    load_direction_instances(West, mesh.west)
    load_direction_instances(Up, mesh.up)
    load_direction_instances(Down, mesh.down)
  end

  def delete
    GL.delete_vertex_arrays(@vertex_array_objects.values)
    GL.delete_buffers(@vertex_buffer_objects.values + @instance_buffer_objects.values)
  end

  def draw
    draw_direction(North)
    draw_direction(South)
    draw_direction(East)
    draw_direction(West)
    draw_direction(Up)
    draw_direction(Down)
  end

  private def load_direction_instances(direction : Direction, faces : Array(XYZ))
    raise "Too many instances" if faces.size > MAX_INSTANCES

    GL.bind_vertex_array(@vertex_array_objects[direction])
    @instances[direction] = Array(Float32).build(3 * faces.size) do |buffer|
      i = 0
      faces.each do |pos|
        buffer[i] = pos.x.to_f32
        buffer[i+1] = pos.y.to_f32
        buffer[i+2] = pos.z.to_f32
        i += 3
      end
      3 * faces.size
    end
    GL.bind_buffer(GL::BufferBindingTarget::ArrayBuffer, @instance_buffer_objects[direction])
    GL.buffer_sub_data(GL::BufferBindingTarget::ArrayBuffer, 0, @instances[direction].size * sizeof(Float32), @instances[direction])
  end

  private def draw_direction(direction : Direction)
    return unless @instances[direction].size > 0

    GL.bind_vertex_array(@vertex_array_objects[direction])
    GL.draw_arrays_instanced(GL::Primitive::Triangles, 0, 6, @instances[direction].size / 3)
  end

  private def gen(direction : Direction)
    GL.bind_vertex_array(@vertex_array_objects[direction])

    # fill the vertex array buffer
    GL.bind_buffer(GL::BufferBindingTarget::ArrayBuffer, @vertex_buffer_objects[direction])
    GL.buffer_data(GL::BufferBindingTarget::ArrayBuffer, VERTICES[direction].size * sizeof(Float32), VERTICES[direction], GL::BufferUsage::StaticDraw)

    # set and enable pointer to vertex position data
    GL.vertex_attrib_pointer(0, 3, GL::Type::Float, false, 6 * sizeof(Float32), 0)
    GL.enable_vertex_attrib_array(0)

    # set and enable pointer to vertex normal data
    GL.vertex_attrib_pointer(1, 3, GL::Type::Float, false, 6 * sizeof(Float32), 3 * sizeof(Float32))
    GL.enable_vertex_attrib_array(1)

    # initialize the instance positions buffer
    GL.bind_buffer(GL::BufferBindingTarget::ArrayBuffer, @instance_buffer_objects[direction])
    GL.buffer_data(GL::BufferBindingTarget::ArrayBuffer, MAX_INSTANCES * 3 * sizeof(Float32), nil, GL::BufferUsage::StreamDraw)
    # set and enable pointer to instance position data
    GL.vertex_attrib_pointer(2, 3, GL::Type::Float, false, 3 * sizeof(Float32), 0)
    GL.vertex_attrib_divisor(2, 1)
    GL.enable_vertex_attrib_array(2)
  end
end
