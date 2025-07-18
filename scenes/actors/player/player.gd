extends CharacterBody2D
class_name Player

const IDLE_DOWN_ANIMATION: String = 'idle_down';
const IDLE_UP_ANIMATION: String = 'idle_up';
const WALK_DOWN_ANIMATION: String = 'walk_down';
const WALK_UP_ANIMATION: String = 'walk_up';

@export var move_speed: float = 300.0
@onready var character_sprite_animation: AnimatedSprite2D = %CharacterSpriteAnimation

var is_traveling_up: bool = false;

func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
		is_traveling_up = false;
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
		is_traveling_up = true;
	
	input_vector = input_vector.normalized();
	velocity = input_vector * move_speed
	move_and_slide()

	if input_vector == Vector2.ZERO:
		if (is_traveling_up):
			character_sprite_animation.play(IDLE_UP_ANIMATION);
		else:
			character_sprite_animation.play(IDLE_DOWN_ANIMATION);
	else:
		if (is_traveling_up):
			character_sprite_animation.play(WALK_UP_ANIMATION);
		else:
			character_sprite_animation.play(WALK_DOWN_ANIMATION);
