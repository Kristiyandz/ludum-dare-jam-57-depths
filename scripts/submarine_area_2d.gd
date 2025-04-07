extends Area2D
var salvage_collected = 0
@onready var submarine: CharacterBody2D = $"."


func _on_area_entered(area:Area2D) -> void:
	if area.collision_mask == 2:
		print('taking damage')
		var world = get_tree().current_scene
		area.queue_free()
		world.hull_integrity -= 20
		var current_integrity = world.get('hull_integrity')
		print(current_integrity)

		if current_integrity <= 0:
			# queue_free()
			submarine.queue_free()
	else:
		salvage_collected += 1
		print('collecting salvage')
	
	
	
