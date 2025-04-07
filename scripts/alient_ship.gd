extends Area2D

@export var collect_prompt: Label

var player_in_range: bool = false

func _ready() -> void:
	if collect_prompt:
		collect_prompt.visible = false

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("colelct"):
		var world = get_tree().current_scene
		world.is_important_item_collected = true
		collect_item()
		EventBus.emit_signal("wakeup_alien_fish")


func collect_item() -> void:
	# Here you can add additional logic (e.g., updating score, playing a sound)
	# Finally, remove the collectible from the scene
	queue_free()


func _on_body_entered(body:Node2D) -> void:
	print('body entered')
	if body.name == 'Submarine':
		print('submarine entered')
		player_in_range = true
		if collect_prompt:
			collect_prompt.text = '(c)'
			collect_prompt.visible = true



func _on_body_exited(body:Node2D) -> void:
	if body.name == 'Submarine':
		player_in_range = false
		if collect_prompt:
			collect_prompt.visible = false

