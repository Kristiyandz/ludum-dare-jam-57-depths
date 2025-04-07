extends Area2D

@onready var animation_layer: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var alient_roar: AudioStreamPlayer = $AudioStreamPlayer

var speed = 35
var is_awake = false  # Flag to track if the fish is awake

func _ready() -> void:
    EventBus.connect("wakeup_alien_fish", wakeup_fish)

func _process(delta: float) -> void:
    # Only move if the fish is awake
    if is_awake:
        await get_tree().create_timer(2).timeout
        animation_layer.play("alien_attack")
        position.y -= speed * delta

func wakeup_fish() -> void:
    is_awake = true  # Set the flag to true when the event is triggered
    alient_roar.play()
