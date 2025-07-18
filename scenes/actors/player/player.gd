extends CharacterBody2D
class_name Player

const IDLE_DOWN_ANIMATION: String = 'idle_down';
const WALK_DOWN_ANIMATION: String = 'walk_down';

@export var move_speed: float = 300.0
@onready var character_sprite_animation: AnimatedSprite2D = %CharacterSpriteAnimation

var is_traveling_up: bool = false;

func _ready() -> void:
	PlayerMessenger.change_player_global_position.connect(_on_change_player_position.bind());

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
		character_sprite_animation.play(IDLE_DOWN_ANIMATION);

	else:
		character_sprite_animation.play(WALK_DOWN_ANIMATION);

func _on_change_player_position(new_position: Vector2):
	self.global_position = new_position;
