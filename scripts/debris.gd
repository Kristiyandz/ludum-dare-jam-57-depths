extends StaticBody2D

@export var float_height: float = 10.0   # Maximum height of the float
@export var float_speed: float = 2.0     # Speed of the floating animation
@export var rotation_speed: float = 0.5  # Speed of rotation (in radians per second)
@export var max_rotation: float = 0.1    # Maximum rotation angle (in radians)

# Store the initial position
var initial_position: Vector2
var initial_rotation: float
var time_passed: float = 0.0

func _ready() -> void:
    # Save the initial position and rotation when the node is ready
    initial_position = global_position
    initial_rotation = rotation

func _process(delta: float) -> void:
    # Increment the time counter
    time_passed += delta * float_speed
    
    # Calculate the new Y position using a sine wave
    # sin() returns values between -1 and 1, so we multiply by float_height/2
    var new_y = initial_position.y + sin(time_passed) * (float_height / 2)
    
    # Calculate a gentle rotation using a cosine wave (offset from sine)
    # This creates a slightly different timing for the rotation than the floating
    var new_rotation = initial_rotation + cos(time_passed * 0.8) * max_rotation
    
    # Update the position and rotation
    global_position.y = new_y
    rotation = new_rotation