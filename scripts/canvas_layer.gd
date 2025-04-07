extends CanvasLayer

@onready var integrity_lael: Label = $HullIntegrity

func _process(_delta: float) -> void:
    var world = get_tree().current_scene
    
    integrity_lael.text = "Hull Integrity: " + str(snapped(world.hull_integrity, 0.1)) + "%"
    
