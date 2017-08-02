require "glfw"

class Window
  getter :delta_time

  def initialize(@width = 1024, @height = 768, @title = "")
    raise "Failed to initialize GLFW" unless GLFW.init

    GLFW.window_hint(GLFW::Hint::ContextVersionMajor, 3)
    GLFW.window_hint(GLFW::Hint::ContextVersionMinor, 3)
    GLFW.window_hint(GLFW::Hint::OpenGLForwardCompat, 1)
    GLFW.window_hint(GLFW::Hint::OpenGLProfile, GLFW::OpenGLProfile::Core)
    GLFW.window_hint(GLFW::Hint::Samples, 8)
    @handle = GLFW.create_window(@width, @height, @title)

    raise "Failed to open GLFW window" if @handle.is_a?(Nil)

    GLFW.set_input_mode(@handle, GLFW::InputMode::Cursor, GLFW::InputModeValue::CursorDisabled)

    @frames = 0
    @last_fps_print = 0.0
    @delta_time = 0.0
    @last_frame = 0.0
  end

  def set_context_current
    GLFW.set_current_context(@handle)
  end

  def set_swap_interval(interval)
    GLFW.swap_interval(interval)
  end

  def open(&block)
    while true
      update_delta_time
      print_fps
      break if key_pressed?(GLFW::Key::Escape) && GLFW.window_should_close(@handle)
      yield @delta_time
      GLFW.swap_buffers(@handle)
      GLFW.poll_events
    end

    GLFW.terminate
  end

  def key_pressed?(key)
    GLFW.get_key(@handle, key) == GLFW::Keystate::Press
  end

  def cursor_position
    GLFW.get_cursor_pos(@handle)
  end

  private def update_delta_time
    current_frame = GLFW.get_time
    @delta_time = current_frame - @last_frame
    @last_frame = current_frame
  end

  private def print_fps
    current_frame = GLFW.get_time
    @frames += 1

    diff = current_frame - @last_fps_print
    if diff >= 2.0
      puts "#{(diff * 1000.0) / @frames} ms/frame"
      @frames = 0
      @last_fps_print += diff
    end
  end
end
