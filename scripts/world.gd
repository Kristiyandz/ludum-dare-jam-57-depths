extends Node2D

@onready var hull_integrity_label = $CanvasLayer/HullIntegrity

@export var submarine: Node2D
@onready var camera_2d: Camera2D = $Camera2D
var time_passed: float = 0.0
var _final_time: float = 0.0

var hull_integrity: float = 100.0 :
	get:
		return hull_integrity
	set(value):
		hull_integrity = value
		hull_integrity_label.text = "Integrity: " + str(hull_integrity)

# check if the important item has been collected
var is_important_item_collected: bool = false:
	get:
		return is_important_item_collected
	set(value):
		is_important_item_collected = value

var has_player_won: bool = false:
	get:
		return has_player_won
	set(value):
		has_player_won = value

# keep track of the best time
var final_time: float:
	get:
			return _final_time
	set(value):
			_final_time = value

# keep track of the salvage count
var salvage_count: int:
	get:
			return salvage_count
	set(value):
			salvage_count = value


func _ready() -> void:
	camera_2d.position.x = submarine.global_position.x
	time_passed = 0.0

func _process(delta):
	# Accumulate game time
	time_passed += delta
	

	if has_player_won: # if player wins, get his current time
		final_time = time_passed

		# current run time
		SaveAndLoad.save_time_attempt_time(final_time) # get the best
		SaveAndLoad.save_attempt_salvage_amount(salvage_count)

		# case 1: no previous best time (null or 0)
		var best_time = SaveAndLoad.load_best_time()
		if best_time == null or best_time == 0:
			SaveAndLoad.save_time(final_time)
		# case 2: new time is smaller than best time
		elif final_time < best_time:
			SaveAndLoad.save_time(final_time)

		# save best salvage count
		var best_salvage_count = SaveAndLoad.load_best_salvage_count()
		if best_salvage_count != null:
			if salvage_count > best_salvage_count:
				SaveAndLoad.save_salvage_amount(salvage_count)
		else:
				SaveAndLoad.save_salvage_amount(salvage_count)
		
		get_tree().change_scene_to_file("res://scenes/win_screen.tscn")


	if submarine:
		# Keep our x as-is, just update y
		camera_2d.position = Vector2(camera_2d.position.x, submarine.global_position.y)
	


func _on_submarine_submarine_destroyed() -> void:
	final_time = time_passed
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")


	# # save the best time
	# var best_time = SaveAndLoad.load_best_time()
	# if best_time != null:
	# 	if final_time > best_time:
	# 		SaveAndLoad.save_time(final_time)
	# else:
	# 	SaveAndLoad.save_time(final_time)

	# var best_salvage_count = SaveAndLoad.load_best_salvage_count()
	# if best_salvage_count != null:
	# 	if salvage_count > best_salvage_count:
	# 		SaveAndLoad.save_salvage_amount(salvage_count)
	# else:
	# 		SaveAndLoad.save_salvage_amount(salvage_count)
