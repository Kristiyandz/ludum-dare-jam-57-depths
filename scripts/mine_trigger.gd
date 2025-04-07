extends Area2D
    
func _on_body_entered(body:Node2D) -> void:
    if body.global_position.y > global_position.y:
        print('entered from the bottom')
        EventBus.send_event()
