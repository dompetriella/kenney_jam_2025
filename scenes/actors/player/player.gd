extends CharacterBody2D
class_name Player

@export var move_speed: float = 300.0

func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
	
	input_vector = input_vector.normalized();
	velocity = input_vector * move_speed
	move_and_slide()
