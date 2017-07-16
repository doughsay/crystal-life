class Cube
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

  MAX_INSTANCES = 1_200_000

  CUBE_SIZE = 0.5_f32

  VERTICES = {
    North => [
      # positions                          # colors                       # tex?
      +CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE,  0.96_f32, 0.52_f32, 0.12_f32,  0.0_f32, 0.0_f32,  # 1
      -CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE,  0.96_f32, 0.52_f32, 0.12_f32,  0.0_f32, 0.0_f32,  # 4
      +CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE,  0.96_f32, 0.52_f32, 0.12_f32,  0.0_f32, 0.0_f32,  # 5
      +CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE,  0.96_f32, 0.52_f32, 0.12_f32,  0.0_f32, 0.0_f32,  # 1
      -CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE,  0.96_f32, 0.52_f32, 0.12_f32,  0.0_f32, 0.0_f32,  # 0
      -CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE,  0.96_f32, 0.52_f32, 0.12_f32,  0.0_f32, 0.0_f32   # 4
    ],
    South => [
      # positions                          # colors                       # tex?
      # -CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE,  0.96_f32, 0.52_f32, 0.12_f32,  0.0_f32, 0.0_f32,  # 2
      # +CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE,  0.96_f32, 0.52_f32, 0.12_f32,  0.0_f32, 0.0_f32,  # 7
      # -CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE,  0.96_f32, 0.52_f32, 0.12_f32,  0.0_f32, 0.0_f32,  # 6
      -CUBE_SIZE * 4, -CUBE_SIZE, +CUBE_SIZE,  0.96_f32, 0.52_f32, 0.12_f32,  1.0_f32, 0.0_f32,  # 2
      +CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE,  0.96_f32, 0.52_f32, 0.12_f32,  0.0_f32, 0.0_f32,  # 3
      +CUBE_SIZE, +CUBE_SIZE * 4, +CUBE_SIZE,  0.96_f32, 0.52_f32, 0.12_f32,  0.0_f32, 1.0_f32   # 7
    ],
    East => [
      # positions                          # colors                    # tex?
      +CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE,  0.9_f32, 0.4_f32, 0.0_f32,  0.0_f32, 0.0_f32,  # 3
      +CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE,  0.9_f32, 0.4_f32, 0.0_f32,  0.0_f32, 0.0_f32,  # 5
      +CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE,  0.9_f32, 0.4_f32, 0.0_f32,  0.0_f32, 0.0_f32,  # 7
      +CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE,  0.9_f32, 0.4_f32, 0.0_f32,  0.0_f32, 0.0_f32,  # 3
      +CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE,  0.9_f32, 0.4_f32, 0.0_f32,  0.0_f32, 0.0_f32,  # 1
      +CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE,  0.9_f32, 0.4_f32, 0.0_f32,  0.0_f32, 0.0_f32   # 5
    ],
    West => [
      # positions                          # colors                    # tex?
      -CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE,  0.9_f32, 0.4_f32, 0.0_f32,  0.0_f32, 0.0_f32,   # 0
      -CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE,  0.9_f32, 0.4_f32, 0.0_f32,  0.0_f32, 0.0_f32,   # 6
      -CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE,  0.9_f32, 0.4_f32, 0.0_f32,  0.0_f32, 0.0_f32,   # 4
      -CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE,  0.9_f32, 0.4_f32, 0.0_f32,  0.0_f32, 0.0_f32,   # 0
      -CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE,  0.9_f32, 0.4_f32, 0.0_f32,  0.0_f32, 0.0_f32,   # 2
      -CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE,  0.9_f32, 0.4_f32, 0.0_f32,  0.0_f32, 0.0_f32    # 6
    ],
    Up => [
      # positions                          # colors                      # tex?
      -CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE,  1.0_f32, 0.66_f32, 0.27_f32,  0.0_f32, 0.0_f32,  # 6
      +CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE,  1.0_f32, 0.66_f32, 0.27_f32,  0.0_f32, 0.0_f32,  # 7
      +CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE,  1.0_f32, 0.66_f32, 0.27_f32,  0.0_f32, 0.0_f32,  # 5
      -CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE,  1.0_f32, 0.66_f32, 0.27_f32,  0.0_f32, 0.0_f32,  # 6
      +CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE,  1.0_f32, 0.66_f32, 0.27_f32,  0.0_f32, 0.0_f32,  # 5
      -CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE,  1.0_f32, 0.66_f32, 0.27_f32,  0.0_f32, 0.0_f32   # 4
    ],
    Down => [
      # positions                          # colors                      # tex?
      -CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE,  1.0_f32, 0.66_f32, 0.27_f32,  0.0_f32, 0.0_f32,  # 0
      +CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE,  1.0_f32, 0.66_f32, 0.27_f32,  0.0_f32, 0.0_f32,  # 1
      +CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE,  1.0_f32, 0.66_f32, 0.27_f32,  0.0_f32, 0.0_f32,  # 3
      -CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE,  1.0_f32, 0.66_f32, 0.27_f32,  0.0_f32, 0.0_f32,  # 0
      +CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE,  1.0_f32, 0.66_f32, 0.27_f32,  0.0_f32, 0.0_f32,  # 3
      -CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE,  1.0_f32, 0.66_f32, 0.27_f32,  0.0_f32, 0.0_f32   # 2
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

  def delete
    GL.delete_vertex_arrays(@vertex_array_objects.values)
    GL.delete_buffers(@vertex_buffer_objects.values + @instance_buffer_objects.values)
  end

  def load_instances(points : Hash(Point, Bool))
    faces = {
      North => ([] of Point),
      South => ([] of Point),
      East => ([] of Point),
      West => ([] of Point),
      Up => ([] of Point),
      Down => ([] of Point)
    }
    points.each_key do |point|
      faces[North] << point unless points.has_key?(point.neighbor(North))
      faces[South] << point unless points.has_key?(point.neighbor(South))
      faces[East] << point unless points.has_key?(point.neighbor(East))
      faces[West] << point unless points.has_key?(point.neighbor(West))
      faces[Up] << point unless points.has_key?(point.neighbor(Up))
      faces[Down] << point unless points.has_key?(point.neighbor(Down))
    end

    load_direction_instances(North, faces[North])
    load_direction_instances(South, faces[South])
    load_direction_instances(East, faces[East])
    load_direction_instances(West, faces[West])
    load_direction_instances(Up, faces[Up])
    load_direction_instances(Down, faces[Down])
  end

  def draw
    draw_direction(North)
    draw_direction(South)
    draw_direction(East)
    draw_direction(West)
    draw_direction(Up)
    draw_direction(Down)
  end

  private def load_direction_instances(direction : Direction, points : Array(Point))
    raise "Too many instances" if points.size > MAX_INSTANCES

    GL.bind_vertex_array(@vertex_array_objects[direction])
    @instances[direction] = Array(Float32).build(3 * points.size) do |buffer|
      i = 0
      points.each do |point|
        buffer[i] = point.x.to_f32
        buffer[i+1] = point.y.to_f32
        buffer[i+2] = point.z.to_f32
        i += 3
      end
      3 * points.size
    end
    GL.bind_buffer(GL::BufferBindingTarget::ArrayBuffer, @instance_buffer_objects[direction])
    GL.buffer_sub_data(GL::BufferBindingTarget::ArrayBuffer, 0, @instances[direction].size * sizeof(Float32), @instances[direction])
  end

  private def draw_direction(direction : Direction)
    return unless @instances[direction].size > 0

    GL.bind_vertex_array(@vertex_array_objects[direction])
    GL.draw_arrays_instanced(GL::Primitive::Triangles, 0, direction.south? ? 3 : 6, @instances[direction].size / 3)
  end

  private def gen(direction : Direction)
    GL.bind_vertex_array(@vertex_array_objects[direction])

    # fill the vertex array buffer
    GL.bind_buffer(GL::BufferBindingTarget::ArrayBuffer, @vertex_buffer_objects[direction])
    GL.buffer_data(GL::BufferBindingTarget::ArrayBuffer, VERTICES[direction].size * sizeof(Float32), VERTICES[direction], GL::BufferUsage::StaticDraw)

    # set and enable pointer to vertex position data
    GL.vertex_attrib_pointer(0, 3, GL::Type::Float, false, 8 * sizeof(Float32), 0)
    GL.enable_vertex_attrib_array(0)

    # set and enable pointer to vertex color data
    GL.vertex_attrib_pointer(1, 3, GL::Type::Float, false, 8 * sizeof(Float32), 3 * sizeof(Float32))
    GL.enable_vertex_attrib_array(1)

    # set and enable pointer to texture coordinate data
    GL.vertex_attrib_pointer(2, 2, GL::Type::Float, false, 8 * sizeof(Float32), 6 * sizeof(Float32))
    GL.enable_vertex_attrib_array(2)

    # fill the instance positions buffer
    GL.bind_buffer(GL::BufferBindingTarget::ArrayBuffer, @instance_buffer_objects[direction])
    # TODO: this buffer is large, but fixed; if more cubes need to be drawn the buffer needs to be resized
    GL.buffer_data(GL::BufferBindingTarget::ArrayBuffer, MAX_INSTANCES * 3 * sizeof(Float32), nil, GL::BufferUsage::StreamDraw)
    # set and enable pointer to instance position data
    GL.vertex_attrib_pointer(3, 3, GL::Type::Float, false, 3 * sizeof(Float32), 0)
    GL.vertex_attrib_divisor(3, 1)
    GL.enable_vertex_attrib_array(3)
  end
end
