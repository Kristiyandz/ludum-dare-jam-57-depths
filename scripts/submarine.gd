extends CharacterBody2D

@onready var submarine_animation: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var submarine_sprite: Sprite2D = $Sprite2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var submarine_sound: AudioStreamPlayer = $PropellerSound
@onready var submarine_hit_sprite: Sprite2D = $HitEffect
@onready var submarine_hit_effect: AnimationPlayer = $HitEffect/AnimationPlayer
@onready var submarine_hit_sound: AudioStreamPlayer = $HitSound
@onready var submarine_collect_salvage_sound: AudioStreamPlayer = $ColelctSavlageSound

@export var rotation_speed: float = 0.1
@export var tilt_angle_deg_up: float = -15.0
@export var tilt_angle_deg_down: float = 15.0
@export var tilt_angle_deg: float = 5.0
@export var rotation_lerp: float = 0.1

@export var speed = 20
@export var surface_y: float = 0.0
@export var pressure_scale: float = 0.0004

@export var acceleration: float = 8.0 # how fast the submarine accelerates when input is given.
@export var max_speed: float = 18.0 # the maximum speed the submarine can reach.
@export var deceleration: float = 5.0 # how quickly the submarine slows down when no input is detected.
var _is_destroying = false

signal submarine_destroyed


func _physics_process(delta: float) -> void:
	var input_vector := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	# normalise to avoid faster diagonal movement.
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		# accelerate towards the input direction.
		velocity += input_vector * acceleration * delta
		
		# clamp velocity to the maximum speed.
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
	else:
		# no input: decelerate gradually by moving velocity towards zero.
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	# Move the character using the updated velocity.
	move_and_slide()

func _process(delta: float) -> void:
	var world = get_tree().current_scene

	var input_up    = Input.is_action_pressed("ui_up")
	var input_down  = Input.is_action_pressed("ui_down")
	var input_left  = Input.is_action_pressed("ui_left")
	var input_right = Input.is_action_pressed("ui_right")
	var is_moving = input_up or input_down or input_left or input_right
    
	if is_moving:
		# Play only once when movement starts
		if not submarine_sound.is_playing():
			submarine_sound.play()

	# Vertical movement
	if input_up:
		if global_position.y < 105: return
		position.y -= speed * delta
		submarine_animation.play("moving")
	elif input_down:
		position.y += speed * delta
		submarine_animation.play("moving")

	# Horizontal movement
	if input_left:
		position.x -= speed * delta
		submarine_animation.play("moving")
		submarine_sprite.scale.x = 1  # Flip sprite to face left
	elif input_right:
		position.x += speed * delta
		submarine_animation.play("moving")
		submarine_sprite.scale.x = -1   # Flip back to face right

	# Figure out facing direction
	var facing_right = (submarine_sprite.scale.x > 0)

	# Determine the "target" rotation angle (in degrees)
	var target_rot_deg = 0.0

	if input_up:
		# If facing right, tilt nose up is negative angle (e.g. -15°)
		# If facing left, tilt nose up is positive angle (e.g. +15°)
		if facing_right:
			target_rot_deg = tilt_angle_deg
		else:
			target_rot_deg = -tilt_angle_deg
	elif input_down:
		# If facing right, tilt nose down is +15°
		# If facing left, tilt nose down is -15°
		if facing_right:
			target_rot_deg = -tilt_angle_deg
		else:
			target_rot_deg = tilt_angle_deg

	# Smoothly rotate from current rotation to the target angle
	submarine_sprite.rotation = lerp(
		submarine_sprite.rotation,
		deg_to_rad(target_rot_deg),
		rotation_lerp
	)
	
	var depth = max(0, position.y - surface_y)
	var current_pressure = depth * pressure_scale
	world.hull_integrity -= current_pressure * delta

	if world.hull_integrity <= 0 and not _is_destroying:
		_handle_destruction()

func _handle_destruction() -> void:
	_is_destroying = true
	submarine_hit_sprite.visible = true
	submarine_hit_effect.play("hit")
	submarine_hit_sound.play()
	await get_tree().create_timer(0.4).timeout
	submarine_hit_sprite.visible = false
	submarine_destroyed.emit()
	queue_free()

func _on_submarine_area_2d_area_entered(area: Area2D) -> void:
	var world = get_tree().current_scene
	# print("Area entered: ", area.name, " - Layer: ", area.collision_layer)
	
	# Match the exact layer values from above
	if area.collision_layer == 1:
		world.salvage_count += 1
		area.queue_free()
		submarine_collect_salvage_sound.play()
	elif area.collision_layer == 2 or area.collision_layer == 8:  # Bomb (layer 3) or Fish (layer 8)
		
		submarine_hit_sprite.visible = true
		submarine_hit_effect.play("hit")
		submarine_hit_sound.play()
		await get_tree().create_timer(0.3).timeout
		submarine_hit_sprite.visible = false
		submarine_destroyed.emit()
		queue_free()
	elif area.collision_layer == 4:  # Damage areas (layer 4)
		print("HIT BY A MINE")
		area.queue_free()
		submarine_hit_sprite.visible = true
		submarine_hit_effect.play("hit")
		submarine_hit_sound.play()
		await get_tree().create_timer(0.3).timeout
		submarine_hit_sprite.visible = false
		world.hull_integrity -= 20
		var current_integrity = world.get('hull_integrity')

		if current_integrity <= 0:
			queue_free()
			submarine_destroyed.emit()
