extends ColorRect

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed('ui_accept'):
        get_tree().change_scene_to_file('res://scenes/world.tscn')
    if Input.is_action_just_pressed('ui_cancel'):
        get_tree().change_scene_to_file('res://scenes/start_menu.tscn')

