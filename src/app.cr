require "gl"
require "./glm"
require "./window"
require "./shader_program"
require "./direction"
require "./point"
require "./camera"
require "./chunk_manager"

class App
  def initialize
    @window = Window.new(1440, 900, "OMG! 3D!")
    @window.set_context_current
    @window.set_swap_interval(0)
    @shader_program = ShaderProgram.new("./src/shaders/cube.vert", "./src/shaders/cube.frag")
    @wireframe = false
    @camera = Camera.new(GLM.vec3(0.0, 130.0, 0.0))
    @first_mouse = true
    @last_x = 0.0
    @last_y = 0.0

    @last_chunk_position = {0, 0}

    @chunk_manager = ChunkManager.new(@last_chunk_position, 12)
  end

  def run
    setup

    @window.open do |delta_time|
      render(delta_time)
    end

    teardown
  end

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

    @chunk_manager.origin = @last_chunk_position
  end

  private def clear
    GL.clear(GL::BufferBit::Color | GL::BufferBit::Depth)
  end

  private def render(delta_time)
    process_input(delta_time)

    if @last_chunk_position != @camera.chunk_position
      @last_chunk_position = @camera.chunk_position
      @chunk_manager.origin = @last_chunk_position
    end

    @chunk_manager.update

    clear

    view = @camera.view_matrix

    @shader_program.use do
      @shader_program.set_uniform_matrix_4f("view", view)
      @shader_program.set_uniform_vector_3f("camera_position", @camera.position)

      @chunk_manager.chunks.each do |point, chunk|
        model = GLM.translate(GLM.vec3(point[0] * 16.0, 0.0, point[1] * 16.0))
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
    @chunk_manager.chunks.values.each(&.unload)
  end
end
