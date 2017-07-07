require "./gl"
require "./glm"
require "./window"
require "./shader_program"
require "./cube"
require "./point"

class App
  def initialize
    @window = Window.new(800, 600, "OMG! 3D!")
    @window.set_context_current
    @shader_program = ShaderProgram.new("./src/shaders/vertex_shader.glsl", "./src/shaders/fragment_shader.glsl")
    @scene = Cube.new
    @rand = Random.new
  end

  def run
    setup

    @window.open do
      render
    end

    teardown
  end

  private def random_cubes(size)
    points = [] of Point
    (-size..size).each do |x|
      (-size..size).each do |y|
        (-size..size).each do |z|
          if @rand.next_bool
            points << Point.new(x, y, z)
          end
        end
      end
    end
    @scene.load_instances(points)
  end

  private def setup
    GL.clear_color(0.6_f32, 0.77_f32, 0.95_f32, 1.0_f32)
    GL.enable(GL::DEPTH_TEST)
    GL.enable(GL::CULL_FACE)

    projection = GLM.perspective(45.0_f32, (800.0 / 600.0).to_f32, 0.1_f32, 1000.0_f32)
    @shader_program.set_uniform_matrix_4f("projection", projection)
  end

  private def clear
    GL.clear(GL::COLOR_BUFFER_BIT | GL::DEPTH_BUFFER_BIT)
  end

  private def render
    clear

    random_cubes(10 + (Math.sin(LibGLFW.get_time) * 10).to_i)

    @shader_program.use do
      model = GLM::Mat4.identity

      view = GLM.translate(GLM.vec3(0.0, 0.0, -50.0))
      view = GLM.rotate(view, GLM.deg_to_rad(-35.0), GLM.vec3(1.0, 0.0, 0.0))
      view = GLM.rotate(view, LibGLFW.get_time, GLM.vec3(0.0, 1.0, 0.0))

      @shader_program.set_uniform_matrix_4f("model", model)
      @shader_program.set_uniform_matrix_4f("view", view)

      @scene.draw
    end
  end

  private def teardown
    @scene.delete
  end
end
