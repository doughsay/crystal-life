require "./glm"

class Camera
  # Defaults
  YAW = -90.0
  PITCH =  0.0
  SPEED =  20.0
  SENSITIVTY =  0.1
  ZOOM =  45.0

  enum Direction
    Forward
    Backward
    Left
    Right
    Up
    Down
  end

  getter :position, :chunk_position

  # Vectors
  @position : GLM::Vec3
  @front : GLM::Vec3
  @up : GLM::Vec3
  @right : GLM::Vec3
  @world_up : GLM::Vec3
  @world_front : GLM::Vec3

  # Euler Angles
  @yaw : Float64
  @pitch : Float64

  # Options
  @speed : Float64
  @sensitivity : Float64
  @zoom : Float64

  def initialize(@position = GLM.vec3(0.0, 0.0, 0.0), @world_up = GLM.vec3(0.0, 1.0, 0.0), @yaw = YAW, @pitch = PITCH, @speed = SPEED, @sensitivity = SENSITIVTY, @zoom = ZOOM)
    @front = GLM.vec3(0.0, 0.0, 0.0)
    @world_front = GLM.vec3(0.0, 0.0, 0.0)
    @up = GLM.vec3(0.0, 0.0, 0.0)
    @right = GLM.vec3(0.0, 0.0, 0.0)
    @chunk_position = XZ.new(0, 0)
    update_vectors
    update_chunk_position
  end

  def view_matrix
    GLM.look_at(@position, @position + @front, @up)
  end

  def process_keyboard(direction : Direction, delta_time : Float64)
    velocity = @speed * delta_time;

    case direction
    when Direction::Forward
      @position += @world_front * velocity
    when Direction::Backward
      @position -= @world_front * velocity
    when Direction::Left
      @position -= @right * velocity
    when Direction::Right
      @position += @right * velocity
    when Direction::Up
      @position += @world_up * velocity
    when Direction::Down
      @position -= @world_up * velocity
    end

    update_chunk_position
  end

  def process_mouse(x_offset : Float64, y_offset : Float64, constrain_pitch : Bool = true)
    x_offset *= @sensitivity
    y_offset *= @sensitivity

    @yaw += x_offset
    @pitch += y_offset

    # Make sure that when pitch is out of bounds, screen doesn't get flipped
    if (constrain_pitch)
      @pitch = 89.0 if @pitch > 89.0
      @pitch = -89.0 if @pitch < -89.0
    end

    # Update Front, Right and Up Vectors using the updated Eular angles
    update_vectors
  end

  private def update_vectors
    # Calculate the new front vector
    @front = GLM.vec3(
      Math.cos(GLM.deg_to_rad(@yaw)) * Math.cos(GLM.deg_to_rad(@pitch)),
      Math.sin(GLM.deg_to_rad(@pitch)),
      Math.sin(GLM.deg_to_rad(@yaw)) * Math.cos(GLM.deg_to_rad(@pitch))
    ).normalize

    # remove the y component and normalize to get a world-front vector
    @world_front = GLM.vec3(@front.x, 0.0, @front.z).normalize

    # Also re-calculate the right and up vector
    @right = @front.cross(@world_up).normalize
    @up = @right.cross(@front).normalize
  end

  private def update_chunk_position
    @chunk_position = XZ.new(@position.x.floor.to_i / 16, @position.z.floor.to_i / 16)
  end
end
