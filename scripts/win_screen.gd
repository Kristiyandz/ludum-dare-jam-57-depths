extends ColorRect

@onready var attempt_time_label: Label = $TimeLabel
@onready var salvage_count_label: Label = $SalvageLabel
@onready var best_time_label: Label = $BestTimeLabel
@onready var best_salvage_count_label: Label = $BestSalvageLabel

func _ready() -> void:
	
	var current_run_time = SaveAndLoad.load_attempt_time()
	var current_run_salvage_count = SaveAndLoad.load_attempt_salvage_count()

	var best_run_time = SaveAndLoad.load_best_time()
	var best_salvage_count = SaveAndLoad.load_best_salvage_count()


	if best_run_time == null: best_run_time = 0
	if best_salvage_count == null: best_salvage_count = 0

	# show the current run information
	attempt_time_label.text = "Time:          " + seconds_to_minutes(current_run_time)
	salvage_count_label.text = "Salvage:     " + str(current_run_salvage_count)

	# show the best done so far so it is comparable or 0 if there are is nothing
	best_time_label.text = seconds_to_minutes(best_run_time)
	best_salvage_count_label.text = str(best_salvage_count)

	print(current_run_time, 'the current run time')
	print(current_run_salvage_count, 'the current salvage count')
	print(best_run_time, 'the best run time')
	print(best_salvage_count, 'the best salvage count')





func _on_new_dive_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_back_to_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")

func seconds_to_minutes(seconds: float) -> String:
	var minutes = int(seconds / 60)
	var remaining_seconds = int(seconds) % 60
	
	# Format as MM:SS with leading zeros if needed
	return "%02d:%02d" % [minutes, remaining_seconds]
