require "glfw"

class Window
  def initialize(@width = 1024, @height = 768, @title = "")
    raise "Failed to initialize GLFW" unless GLFW.init

    GLFW.window_hint(GLFW::Hint::ContextVersionMajor, 3)
    GLFW.window_hint(GLFW::Hint::ContextVersionMinor, 3)
    GLFW.window_hint(GLFW::Hint::OpenGLForwardCompat, 1)
    GLFW.window_hint(GLFW::Hint::OpenGLProfile, GLFW::OpenGLProfile::Core)
    @handle = GLFW.create_window(@width, @height, @title)

    raise "Failed to open GLFW window" if @handle.is_a?(Nil)

    @last_time = GLFW.get_time
    @frames = 0
  end

  def set_context_current
    GLFW.set_current_context(@handle)
  end

  def open(&block)
    while true
      print_fps
      GLFW.poll_events
      break if key_pressed?(GLFW::Key::Escape) && GLFW.window_should_close(@handle)
      yield
      GLFW.swap_buffers(@handle)
    end

    GLFW.terminate
  end

  def key_pressed?(key)
    GLFW.get_key(@handle, key) == GLFW::Keystate::Press
  end

  private def print_fps
    current_time = GLFW.get_time
    @frames += 1

    diff = current_time - @last_time
    if diff >= 1.0
      puts "#{(diff * 1000.0) / @frames} ms/frame"
      @frames = 0
      @last_time += diff
    end
  end
end
