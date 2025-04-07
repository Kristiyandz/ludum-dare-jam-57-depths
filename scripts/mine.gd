extends Area2D

@export var speed = 50
@export var is_moving_left: bool
@export var spin_speed: float = 0 

func _process(delta: float) -> void:
    if is_moving_left:
        position.x -= speed * delta
    else:
        position.x += speed * delta

    rotation += spin_speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
    queue_free()
