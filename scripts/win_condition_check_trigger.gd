extends Area2D

func _on_body_entered(body:Node2D) -> void:
    if body.name == 'Submarine':
        print('checking win condition')
        if body.global_position.y > global_position.y:
            var world = get_tree().current_scene
            var is_item_collected = world.get("is_important_item_collected")
            if is_item_collected:
                world.has_player_won = true

