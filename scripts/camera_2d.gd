extends Camera2D

@export var player: Node2D
@export var camera_speed := 4.0
@export var bottom_limit := 1745

func _ready():
    # Make this the active camera
    make_current()
    
    # Set built-in Camera2D limits so it won’t go below y = bottom_limit
    limit_bottom = bottom_limit
    
    # If you also want to limit how far up, left or right the camera can go:
    # limit_top = 0
    # limit_left = -999999
    # limit_right = 999999

func _process(delta):
    if player == null:
        return
    
    # For a simple "hard follow," you can just set:
    # global_position = player.global_position
    # But let's do a smooth follow:
    var target_pos = player.global_position
    global_position = global_position.lerp(target_pos, camera_speed * delta)
