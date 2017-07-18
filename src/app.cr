require "gl"
require "./glm"
require "./window"
require "./shader_program"
require "./direction"
require "./cube_new"
require "./point"
require "./noise"

class App
  def initialize
    @window = Window.new(1440, 900, "OMG! 3D!")
    @window.set_context_current
    @shader_program = ShaderProgram.new("./src/shaders/vertex_shader.glsl", "./src/shaders/fragment_shader.glsl")
    @scene = Cube.new
    @rand = Random.new
    @camera_rot = 0.0
    @camera_zoom = -100.0
    @camera_tilt = -0.61
    @points = {} of Point => Bool
  end

  def run
    setup

    @window.open do
      render
    end

    teardown
  end

  private def random_cubes(size)
    @points = {} of Point => Bool
    (-size..size).each do |x|
      (-size..size).each do |y|
        (-size..size).each do |z|
          if @rand.next_bool
            @points[Point.new(x, y, z)] = true
          end
        end
      end
    end
    puts @points.size
    @scene.load_instances(@points)
  end

  private def fill_cubes(size)
    @points = {} of Point => Bool
    (-size..size).each do |x|
      (-size..size).each do |y|
        (-size..size).each do |z|
          @points[Point.new(x, y, z)] = true
        end
      end
    end
    puts @points.size
    @scene.load_instances(@points)
  end

  private def noise_cubes(size)
    @points = {} of Point => Bool
    (-size..size).each do |x|
      (-size..size).each do |y|
        (-size..size).each do |z|
          if Noise.generate(x.to_f / 30.0, y.to_f / 30.0, z.to_f / 30.0) > 0.05
            @points[Point.new(x, y, z)] = true
          end
        end
      end
    end
    puts @points.size
    @scene.load_instances(@points)
  end

  private def setup
    GL.clear_color(GL::Color.new(0.2, 0.3, 0.5, 1.0))
    GL.enable(GL::Capability::DepthTest)
    GL.enable(GL::Capability::CullFace)
    # GL.polygon_mode(GL::PolygonFace::FrontAndBack, GL::PolygonMode::Line)

    projection = GLM.perspective(45.0_f32, (1440.0 / 900.0).to_f32, 0.1_f32, 1000.0_f32)
    @shader_program.set_uniform_matrix_4f("projection", projection)

    # noise_cubes(120)
    # fill_cubes(1)
    # @scene.load_instances({Point.new(0,0,0) => true})
    noise_cubes(20)
  end

  private def clear
    GL.clear(GL::BufferBit::Color | GL::BufferBit::Depth)
  end

  private def render
    clear

    # random_cubes(20 + (Math.sin(GLFW.get_time) * 20).to_i)
    # random_cubes(40)

    model = GLM::Mat4.identity

    @camera_rot += 0.02 if @window.key_pressed?(GLFW::Key::Left)
    @camera_rot -= 0.02 if @window.key_pressed?(GLFW::Key::Right)
    # @camera_tilt += 0.02 if @window.key_pressed?(GLFW::Key::Up)
    # @camera_tilt -= 0.02 if @window.key_pressed?(GLFW::Key::Down)
    @camera_zoom += 1.0 if @window.key_pressed?(GLFW::Key::Up)
    @camera_zoom -= 1.0 if @window.key_pressed?(GLFW::Key::Down)

    camera_x = -@camera_zoom * Math.sin(@camera_rot)
    camera_y = @camera_zoom * Math.sin(@camera_tilt)
    camera_z = -@camera_zoom * Math.cos(@camera_rot) * Math.cos(@camera_tilt)

    # if @window.key_pressed?(GLFW::Key::Space)
    #   # sort points:
    #   @points.sort_by! do |point|
    #     Math.sqrt((camera_x - point.x) ** 2 + (camera_y - point.y) ** 2 + (camera_z - point.z) ** 2)
    #   end
    #   @scene.load_instances(@points)
    # end

    # if @window.key_pressed?(GLFW::Key::Space)
    #   random_cubes(70)
    # end

    view = GLM.translate(GLM.vec3(0.0, 0.0, @camera_zoom))
    view = GLM.rotate(view, @camera_tilt, GLM.vec3(1.0, 0.0, 0.0))
    view = GLM.rotate(view, @camera_rot, GLM.vec3(0.0, 1.0, 0.0))

    @shader_program.use do
      @shader_program.set_uniform_matrix_4f("model", model)
      @shader_program.set_uniform_matrix_4f("view", view)
      @shader_program.set_uniform_vector_3f("camera_position", GLM.vec3(camera_x, camera_y, camera_z))

      @scene.draw
    end
  end

  private def teardown
    @scene.delete
  end
end
