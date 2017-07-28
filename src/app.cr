require "gl"
require "./glm"
require "./window"
require "./shader_program"
require "./direction"
# require "./cube_new"
require "./point"
# require "./noise"
require "./camera"
require "./chunk"

class App
  def initialize
    @window = Window.new(1440, 900, "OMG! 3D!")
    @window.set_context_current
    @shader_program = ShaderProgram.new("./src/shaders/cube.vert", "./src/shaders/cube.frag")
    # @scene = Cube.new
    # @rand = Random.new
    # @points = {} of Point => Bool
    @wireframe = false
    @camera = Camera.new(GLM.vec3(0.0, 130.0, 0.0))
    @first_mouse = true
    @last_x = 0.0
    @last_y = 0.0

    @chunks = [] of Chunk
  end

  def run
    setup

    @window.open do |delta_time|
      render(delta_time)
    end

    teardown
  end

  # private def random_cubes(size)
  #   @points = {} of Point => Bool
  #   (-size..size).each do |x|
  #     (-size..size).each do |y|
  #       (-size..size).each do |z|
  #         if @rand.next_bool
  #           @points[Point.new(x, y, z)] = true
  #         end
  #       end
  #     end
  #   end
  #   puts @points.size
  #   @scene.load_instances(@points)
  # end
  #
  # private def fill_cubes(size)
  #   @points = {} of Point => Bool
  #   (-size..size).each do |x|
  #     (-size..size).each do |y|
  #       (-size..size).each do |z|
  #         @points[Point.new(x, y, z)] = true
  #       end
  #     end
  #   end
  #   puts @points.size
  #   @scene.load_instances(@points)
  # end
  #
  # private def noise_cubes(size)
  #   @points = {} of Point => Bool
  #   (-size..size).each do |x|
  #     (-size..size).each do |y|
  #       (-size..size).each do |z|
  #         if Noise.generate(x.to_f / 30.0, y.to_f / 30.0, z.to_f / 30.0) > 0.05
  #           @points[Point.new(x, y, z)] = true
  #         end
  #       end
  #     end
  #   end
  #   puts @points.size
  #   @scene.load_instances(@points)
  # end
  #
  # private def chunks(origins)
  #   @points = {} of Point => Bool
  #   origins.each do |origin|
  #     (0...128).each do |cy|
  #       (0...16).each do |cz|
  #         (0...16).each do |cx|
  #           x = cx + (origin.x * 16)
  #           y = cy + (origin.y * 128)
  #           z = cz + (origin.z * 16)
  #           if Noise.generate(x.to_f / 30.0, y.to_f / 30.0, z.to_f / 30.0) > 0.05
  #             @points[Point.new(x, y, z)] = true
  #           end
  #         end
  #       end
  #     end
  #   end
  #   puts @points.size
  #   @scene.load_instances(@points)
  # end

  private def setup
    GL.clear_color(GL::Color.new(0.2, 0.3, 0.5, 1.0))
    GL.enable(GL::Capability::DepthTest)
    GL.enable(GL::Capability::CullFace)
    GL.enable(GL::Capability::Multisample)

    # wireframe mode
    if @wireframe
      GL.enable(GL::Capability::LineSmooth)
      GL.line_width(2.0)
      GL.polygon_mode(GL::PolygonFace::FrontAndBack, GL::PolygonMode::Line)
    end

    projection = GLM.perspective(45.0_f32, (1440.0 / 900.0).to_f32, 0.1_f32, 1000.0_f32)
    @shader_program.set_uniform_matrix_4f("projection", projection)

    # noise_cubes(120)
    # fill_cubes(1)
    # @scene.load_instances({Point.new(2,0,0) => true, Point.new(-2,0,0) => true})
    # noise_cubes(30)
    # @scene.load_instances({Point.new(0,0,0) => true, Point.new(1,1,0) => true})
    # chunks([
    #   Point.new(-1,0,-1), Point.new(-1,0,0), Point.new(-1,0,1),
    #   Point.new(0,0,-1), Point.new(0,0,0), Point.new(0,0,1),
    #   Point.new(1,0,-1), Point.new(1,0,0), Point.new(1,0,1)
    # ])

    (-10..10).each do |z|
      (-10..10).each do |x|
        @chunks << Chunk.new({x: x, z: z})
      end
    end
  end

  private def clear
    GL.clear(GL::BufferBit::Color | GL::BufferBit::Depth)
  end

  private def render(delta_time)
    process_input(delta_time)

    clear

    view = @camera.view_matrix

    @shader_program.use do
      @shader_program.set_uniform_matrix_4f("view", view)
      @shader_program.set_uniform_vector_3f("camera_position", @camera.position)

      @chunks.each do |chunk|
        model = GLM.translate(GLM.vec3(chunk.coords[:x] * 16.0, 0.0, chunk.coords[:z] * 16.0))
        @shader_program.set_uniform_matrix_4f("model", model)
        chunk.render
      end
    end
  end

  private def process_input(delta_time)
    process_keyboard_input(delta_time)
    process_mouse_input
  end

  private def process_keyboard_input(delta_time)
    if @window.key_pressed?(GLFW::Key::W)
      @camera.process_keyboard(Camera::Direction::Forward, delta_time)
    end

    if @window.key_pressed?(GLFW::Key::S)
      @camera.process_keyboard(Camera::Direction::Backward, delta_time)
    end

    if @window.key_pressed?(GLFW::Key::A)
      @camera.process_keyboard(Camera::Direction::Left, delta_time)
    end

    if @window.key_pressed?(GLFW::Key::D)
      @camera.process_keyboard(Camera::Direction::Right, delta_time)
    end

    if @window.key_pressed?(GLFW::Key::LeftShift)
      @camera.process_keyboard(Camera::Direction::Down, delta_time)
    end

    if @window.key_pressed?(GLFW::Key::Space)
      @camera.process_keyboard(Camera::Direction::Up, delta_time)
    end
  end

  private def process_mouse_input
    x, y = @window.cursor_position

    if @first_mouse
      @last_x = x
      @last_y = y
      @first_mouse = false
    end

    x_offset = x - @last_x
    y_offset = @last_y - y

    @last_x = x
    @last_y = y

    @camera.process_mouse(x_offset, y_offset)
  end

  private def teardown
    @chunks.each(&.unload)
  end
end
