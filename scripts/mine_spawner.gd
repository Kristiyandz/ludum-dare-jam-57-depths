extends Node2D

const MINE_SCENE = preload("res://scenes/mine.tscn")
@onready var mine_spawn_points = $MineSpawPoints
@onready var timer: Timer = $Timer
@export var mines_moving_left: bool = true

func _ready() -> void:
	# timer.autostart = false
	EventBus.connect("trigger_mines", _trigger_timer, 0)

func _trigger_timer() -> void:
	print('starting timer')
	timer.wait_time = 2
	timer.start()

func spawn_mines() -> void:
	var mine_one = MINE_SCENE.instantiate()
	var mine_two = MINE_SCENE.instantiate()
	mine_one.is_moving_left = mines_moving_left
	mine_two.is_moving_left = mines_moving_left

	mine_one.rotation = randf_range(0, 2 * PI)
	mine_two.rotation = randf_range(0, 2 * PI)

	var world = get_tree().current_scene
	world.add_child(mine_one)
	world.add_child(mine_two)

	mine_one.global_position = get_random_spawn_points()
	mine_two.global_position = get_random_spawn_points()

func get_random_spawn_points() -> Vector2:
	var all_points: Array[Node] = mine_spawn_points.get_children()
	var point = all_points.pick_random()
	return point.global_position


func _on_timer_timeout() -> void:
	print('timeout callded')
	spawn_mines()
